import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/airing_today_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAiringTodayTvBloc
    extends MockBloc<AiringTodayTvEvent, AiringTodayTvState>
    implements AiringTodayTvBloc {}

class _FakeAiringTodayTvEvent extends Fake implements AiringTodayTvEvent {}

class _FakeAiringTodayTvState extends Fake implements AiringTodayTvState {}

void main() {
  late _MockAiringTodayTvBloc mockBloc;

  setUp(() {
    mockBloc = _MockAiringTodayTvBloc();
  });

  setUpAll(() {
    registerFallbackValue(_FakeAiringTodayTvEvent());
    registerFallbackValue(_FakeAiringTodayTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<AiringTodayTvBloc>.value(value: mockBloc, child: body),
    );
  }

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<AiringTodayTvState>.fromIterable([AiringTodayTvLoading()]),
      initialState: AiringTodayTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const AiringTodayTvPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should show TV list when state is loaded', (tester) async {
    final tvList = [
      const Tv(
        id: 1,
        name: 'TV 1',
        overview: 'Overview 1',
        posterPath: '/path1.jpg',
        voteAverage: 8.0,
      ),
      const Tv(
        id: 2,
        name: 'TV 2',
        overview: 'Overview 2',
        posterPath: '/path2.jpg',
        voteAverage: 7.5,
      ),
    ];

    whenListen(
      mockBloc,
      Stream<AiringTodayTvState>.fromIterable([AiringTodayTvLoaded(tvList)]),
      initialState: AiringTodayTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const AiringTodayTvPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCardList), findsNWidgets(2));
  });

  testWidgets('should show error message when state is error', (tester) async {
    const errorMessage = 'Failed to load airing today TV series';

    whenListen(
      mockBloc,
      Stream<AiringTodayTvState>.fromIterable([
        const AiringTodayTvError(errorMessage),
      ]),
      initialState: AiringTodayTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const AiringTodayTvPage()));
    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should show AppBar with correct title', (tester) async {
    whenListen(
      mockBloc,
      Stream<AiringTodayTvState>.fromIterable([]),
      initialState: AiringTodayTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const AiringTodayTvPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Airing Today TV Series'), findsOneWidget);
  });

  testWidgets('should dispatch FetchAiringTodayTv event on init', (
    tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<AiringTodayTvState>.fromIterable([]),
      initialState: AiringTodayTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const AiringTodayTvPage()));
    await tester.pump(Duration.zero);

    verify(() => mockBloc.add(FetchAiringTodayTv())).called(1);
  });
}
