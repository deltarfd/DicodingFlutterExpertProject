import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';
import '../../helpers/test_http_overrides.dart';

class MockOnTheAirTvBloc extends MockBloc<OnTheAirTvEvent, OnTheAirTvState>
    implements OnTheAirTvBloc {}

class MockAiringTodayTvBloc
    extends MockBloc<AiringTodayTvEvent, AiringTodayTvState>
    implements AiringTodayTvBloc {}

class MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class FakeOnTheAirTvEvent extends Fake implements OnTheAirTvEvent {}

class FakeOnTheAirTvState extends Fake implements OnTheAirTvState {}

class FakeAiringTodayTvEvent extends Fake implements AiringTodayTvEvent {}

class FakeAiringTodayTvState extends Fake implements AiringTodayTvState {}

class FakePopularTvEvent extends Fake implements PopularTvEvent {}

class FakePopularTvState extends Fake implements PopularTvState {}

class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

void main() {
  late MockOnTheAirTvBloc mockOnTheAirTvBloc;
  late MockAiringTodayTvBloc mockAiringTodayTvBloc;
  late MockPopularTvBloc mockPopularTvBloc;
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
    registerFallbackValue(FakeOnTheAirTvEvent());
    registerFallbackValue(FakeOnTheAirTvState());
    registerFallbackValue(FakeAiringTodayTvEvent());
    registerFallbackValue(FakeAiringTodayTvState());
    registerFallbackValue(FakePopularTvEvent());
    registerFallbackValue(FakePopularTvState());
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());
  });

  setUp(() {
    mockOnTheAirTvBloc = MockOnTheAirTvBloc();
    mockAiringTodayTvBloc = MockAiringTodayTvBloc();
    mockPopularTvBloc = MockPopularTvBloc();
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnTheAirTvBloc>.value(value: mockOnTheAirTvBloc),
        BlocProvider<AiringTodayTvBloc>.value(value: mockAiringTodayTvBloc),
        BlocProvider<PopularTvBloc>.value(value: mockPopularTvBloc),
        BlocProvider<TopRatedTvBloc>.value(value: mockTopRatedTvBloc),
      ],
      child: MaterialApp(
        home: body,
        routes: {
          '/tv-detail': (context) =>
              const Scaffold(body: Text('TV Detail Page')),
          '/watchlist-tv': (context) =>
              const Scaffold(body: Text('Watchlist TV Page')),
          '/search-tv': (context) =>
              const Scaffold(body: Text('Search TV Page')),
          '/airing-today-tv': (context) =>
              const Scaffold(body: Text('Airing Today TV Page')),
          '/popular-tv': (context) =>
              const Scaffold(body: Text('Popular TV Page')),
          '/top-rated-tv': (context) =>
              const Scaffold(body: Text('Top Rated TV Page')),
        },
      ),
    );
  }

  final tTvList = [
    const Tv(
      id: 1,
      name: 'Test TV',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
    ),
  ];

  group('HomeTvPage', () {
    testWidgets('displays error message when OnTheAir fails', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load On The Air TV';
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: const OnTheAirTvError(errorMessage),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoaded(tTvList),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoaded(tTvList),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoaded(tTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays error message when AiringToday fails', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load Airing Today';
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoaded(tTvList),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: const AiringTodayTvError(errorMessage),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoaded(tTvList),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoaded(tTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays error message when Popular fails', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load Popular';
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoaded(tTvList),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoaded(tTvList),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: const PopularTvError(errorMessage),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoaded(tTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays error message when TopRated fails', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load Top Rated';
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoaded(tTvList),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoaded(tTvList),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoaded(tTvList),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: const TopRatedTvError(errorMessage),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display AppBar with correct title', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoading(),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoading(),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoading(),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoading(),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);
    });

    testWidgets('should dispatch all events on init', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoading(),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoading(),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoading(),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoading(),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump(Duration.zero);

      verify(() => mockOnTheAirTvBloc.add(FetchOnTheAirTv())).called(1);
      verify(() => mockAiringTodayTvBloc.add(FetchAiringTodayTv())).called(1);
      verify(() => mockPopularTvBloc.add(FetchPopularTv())).called(1);
      verify(() => mockTopRatedTvBloc.add(FetchTopRatedTv())).called(1);
    });

    testWidgets('should navigate to search page when search icon tapped', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoading(),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoading(),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoading(),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoading(),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      final searchIcon = find.byIcon(Icons.search);
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
    });

    testWidgets('should navigate to watchlist page when bookmark icon tapped', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoading(),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoading(),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoading(),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoading(),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      final bookmarkIcon = find.byIcon(Icons.bookmark);
      expect(bookmarkIcon, findsOneWidget);
      await tester.tap(bookmarkIcon);
    });

    testWidgets('should navigate when See More buttons are tapped', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoaded(tTvList),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoaded(tTvList),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoaded(tTvList),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoaded(tTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      // Find and tap all See More buttons
      final seeMoreTexts = find.text('See More');
      expect(
        seeMoreTexts,
        findsNWidgets(3),
      ); // Airing Today, Popular, Top Rated

      // Tap each See More button
      for (int i = 0; i < 3; i++) {
        await tester.tap(seeMoreTexts.at(i));
        await tester.pump();
      }
    });

    testWidgets('should navigate to detail page when TV poster is tapped', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockOnTheAirTvBloc,
        Stream<OnTheAirTvState>.fromIterable([]),
        initialState: OnTheAirTvLoaded(tTvList),
      );
      whenListen(
        mockAiringTodayTvBloc,
        Stream<AiringTodayTvState>.fromIterable([]),
        initialState: AiringTodayTvLoaded(tTvList),
      );
      whenListen(
        mockPopularTvBloc,
        Stream<PopularTvState>.fromIterable([]),
        initialState: PopularTvLoaded(tTvList),
      );
      whenListen(
        mockTopRatedTvBloc,
        Stream<TopRatedTvState>.fromIterable([]),
        initialState: TopRatedTvLoaded(tTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      // Find and tap TV poster (InkWell)
      final inkWell = find.byType(InkWell).first;
      await tester.tap(inkWell);
    });
  });
}
