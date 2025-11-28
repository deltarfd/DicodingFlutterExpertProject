import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_search_page.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_http_overrides.dart';

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MockTvSearchBloc mockTvSearchBloc;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockTvSearchBloc = MockTvSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchBloc>.value(
      value: mockTvSearchBloc,
      child: MaterialApp(home: body),
    );
  }

  void arrangeState(TvSearchState state) {
    when(() => mockTvSearchBloc.state).thenReturn(state);
    when(
      () => mockTvSearchBloc.stream,
    ).thenAnswer((_) => Stream<TvSearchState>.value(state));
  }

  final tTvList = <Tv>[
    const Tv(
      id: 1,
      name: 'Test TV',
      overview: 'Overview',
      posterPath: '/path',
      voteAverage: 8.0,
    ),
  ];

  testWidgets('shows helper text when idle', (tester) async {
    arrangeState(TvSearchInitial());

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    expect(find.text('Type at least 2 characters to search'), findsOneWidget);
  });

  testWidgets('shows loading skeleton when loading', (tester) async {
    arrangeState(TvSearchLoading());

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows tv cards when loaded with data', (tester) async {
    arrangeState(TvSearchLoaded(tTvList));

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    expect(find.byType(TvCardList), findsOneWidget);
  });

  testWidgets('shows empty message when loaded with empty data', (
    tester,
  ) async {
    arrangeState(const TvSearchLoaded([]));

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('shows error message when bloc emits error', (tester) async {
    arrangeState(const TvSearchError('Boom'));

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    expect(find.text('Boom'), findsOneWidget);
  });

  testWidgets('submits query when user searches via keyboard action', (
    tester,
  ) async {
    arrangeState(TvSearchInitial());

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    await tester.enterText(find.byType(TextField), 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(
      () => mockTvSearchBloc.add(const SubmitTvQuery('spiderman')),
    ).called(1);
  });

  testWidgets('debounced onChanged triggers search and shows clear button', (
    tester,
  ) async {
    arrangeState(TvSearchInitial());

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));

    await tester.enterText(find.byType(TextField), 'naruto');
    await tester.pump(const Duration(milliseconds: 450));

    verify(() => mockTvSearchBloc.add(const SubmitTvQuery('naruto'))).called(1);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('clear button resets query and dispatches ClearTvQuery', (
    tester,
  ) async {
    arrangeState(TvSearchInitial());

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));
    await tester.enterText(find.byType(TextField), 'bleach');
    await tester.pump(const Duration(milliseconds: 450));
    verify(() => mockTvSearchBloc.add(const SubmitTvQuery('bleach'))).called(1);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    verify(() => mockTvSearchBloc.add(const ClearTvQuery())).called(1);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets(
    'renders recent chips from SharedPreferences and taps trigger search',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'recent_searches_tv': ['Naruto', 'Bleach'],
      });
      arrangeState(TvSearchInitial());

      await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));
      await tester.pump(); // wait for _loadRecent setState

      expect(find.text('Recent'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, 'Naruto'), findsOneWidget);

      await tester.tap(find.widgetWithText(ActionChip, 'Naruto'));
      await tester.pump();

      verify(
        () => mockTvSearchBloc.add(const SubmitTvQuery('Naruto')),
      ).called(1);
    },
  );

  testWidgets('clear recent button removes chips', (tester) async {
    SharedPreferences.setMockInitialValues({
      'recent_searches_tv': ['Naruto'],
    });
    arrangeState(TvSearchInitial());

    await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.clear_all));
    await tester.pump();

    expect(find.widgetWithText(ActionChip, 'Naruto'), findsNothing);
  });

  // TODO: Fix flaky pull-to-refresh test
  // testWidgets('pull-to-refresh re-dispatches last query', (tester) async {
  //   when(() => mockTvSearchBloc.state).thenReturn(TvSearchLoaded(tTvList));
  //   when(() => mockTvSearchBloc.add(const SubmitTvQuery('spiderman')))
  //       .thenAnswer((_) async {});
  //
  //   await tester.pumpWidget(_makeTestableWidget(const TvSearchPage()));
  //   await tester.enterText(find.byType(TextField), 'spiderman');
  //   await tester.testTextInput.receiveAction(TextInputAction.search);
  //   await tester.pump();
  //
  //   await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
  //   controller.add(TvSearchLoading());
  //   await tester.pump();
  //   controller.add(TvSearchLoaded(tTvList));
  //   await tester.pump();

  //   // Wait for refresh to complete
  //   await tester.pump(const Duration(seconds: 1)); // finish animation

  //   verify(
  //     () => mockTvSearchBloc.add(const SubmitTvQuery('One Piece')),
  //   ).called(1);
  //   // Total calls should be 2 (1 initial + 1 refresh)
  // });
}
