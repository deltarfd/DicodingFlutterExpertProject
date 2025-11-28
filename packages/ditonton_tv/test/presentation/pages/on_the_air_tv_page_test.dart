import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/on_the_air_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOnTheAirTvBloc extends MockBloc<OnTheAirTvEvent, OnTheAirTvState>
    implements OnTheAirTvBloc {}

class _FakeOnTheAirTvEvent extends Fake implements OnTheAirTvEvent {}

class _FakeOnTheAirTvState extends Fake implements OnTheAirTvState {}

void main() {
  late _MockOnTheAirTvBloc mockBloc;

  setUp(() {
    mockBloc = _MockOnTheAirTvBloc();
  });

  setUpAll(() {
    registerFallbackValue(_FakeOnTheAirTvEvent());
    registerFallbackValue(_FakeOnTheAirTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<OnTheAirTvBloc>.value(value: mockBloc, child: body),
    );
  }

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<OnTheAirTvState>.fromIterable([OnTheAirTvLoading()]),
      initialState: OnTheAirTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const OnTheAirTvPage()));
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
      Stream<OnTheAirTvState>.fromIterable([OnTheAirTvLoaded(tvList)]),
      initialState: OnTheAirTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const OnTheAirTvPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCardList), findsNWidgets(2));
  });

  testWidgets('should show error message when state is error', (tester) async {
    const errorMessage = 'Failed to load on the air TV series';

    whenListen(
      mockBloc,
      Stream<OnTheAirTvState>.fromIterable([
        const OnTheAirTvError(errorMessage),
      ]),
      initialState: OnTheAirTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const OnTheAirTvPage()));
    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should show AppBar with correct title', (tester) async {
    whenListen(
      mockBloc,
      Stream<OnTheAirTvState>.fromIterable([]),
      initialState: OnTheAirTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const OnTheAirTvPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('On The Air TV Series'), findsOneWidget);
  });

  testWidgets('should dispatch FetchOnTheAirTv event on init', (tester) async {
    whenListen(
      mockBloc,
      Stream<OnTheAirTvState>.fromIterable([]),
      initialState: OnTheAirTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const OnTheAirTvPage()));
    await tester.pump(Duration.zero);

    verify(() => mockBloc.add(FetchOnTheAirTv())).called(1);
  });
}
