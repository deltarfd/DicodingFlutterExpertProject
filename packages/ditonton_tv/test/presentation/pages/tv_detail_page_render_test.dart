import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import '../../helpers/test_http_overrides.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class MockTvDetailNotifier extends Mock implements TvDetailNotifier {}

class MockGetSeasonDetail extends Mock implements GetSeasonDetail {}

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

class TestBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main() {
  late MockTvDetailBloc mockBloc;
  late MockTvDetailNotifier mockNotifier;
  late MockGetSeasonDetail mockGetSeasonDetail;

  setUpAll(() {
    Bloc.observer = TestBlocObserver();
    HttpOverrides.global = TestHttpOverrides();
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
  });

  setUp(() {
    mockBloc = MockTvDetailBloc();
    mockNotifier = MockTvDetailNotifier();
    mockGetSeasonDetail = MockGetSeasonDetail();

    when(() => mockNotifier.getSeasonDetail).thenReturn(mockGetSeasonDetail);
  });

  Widget makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<TvDetailBloc>.value(value: mockBloc),
        ChangeNotifierProvider<TvDetailNotifier>.value(value: mockNotifier),
      ],
      child: MaterialApp(
        home: body,
        routes: {TvDetailPage.ROUTE_NAME: (context) => body},
      ),
    );
  }

  const tId = 1;
  const tTvDetail = TvDetail(
    genres: [
      Genre(id: 1, name: 'Action'),
      Genre(id: 2, name: 'Drama'),
    ],
    id: 1,
    overview: 'This is a test TV show overview',
    posterPath: '/posterPath.jpg',
    name: 'Test TV Show',
    voteAverage: 8.5,
    seasons: [],
  );

  const tTvDetailWithSeasons = TvDetail(
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: '/posterPath',
    name: 'Test TV',
    voteAverage: 8.5,
    seasons: [
      Season(
        id: 101,
        name: 'Season 1',
        episodeCount: 10,
        seasonNumber: 1,
        posterPath: '/season1.jpg',
      ),
    ],
  );

  const tTvDetailWithMultipleSeasons = TvDetail(
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: '/posterPath',
    name: 'Test TV',
    voteAverage: 8.5,
    seasons: [
      Season(
        id: 101,
        name: 'Season 1',
        episodeCount: 10,
        seasonNumber: 1,
        posterPath: '/season1.jpg',
      ),
      Season(
        id: 102,
        name: 'Season 2',
        episodeCount: 10,
        seasonNumber: 2,
        posterPath: '/season2.jpg',
      ),
    ],
  );

  final tTv = Tv(
    id: 2,
    name: 'Recommendation',
    overview: 'rec overview',
    posterPath: '/rec.jpg',
    voteAverage: 7.0,
  );

  final tSeasonDetail = SeasonDetail(
    id: 101,
    seasonNumber: 1,
    episodes: [
      Episode(
        id: 1001,
        name: 'Episode 1',
        episodeNumber: 1,
        overview: 'First episode',
        stillPath: '/ep1.jpg',
      ),
    ],
  );

  group('TvDetailPage - Render Test', () {
    testWidgets('renders and dispatches event on init', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(TvDetailState.initial());
      when(
            () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(TvDetailState.initial()));

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      verify(() => mockBloc.add(const FetchTvDetailEvent(tId))).called(1);
    });

    testWidgets('renders loading state', (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('renders error state', (WidgetTester tester) async {
      const errorMessage = 'Failed to load';
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.error,
          message: errorMessage,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.error,
            message: errorMessage,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('renders loaded state with all content', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetail,
          recommendations: [tTv],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [tTv],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Test TV Show'), findsOneWidget);
      expect(find.text('Action, Drama'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders check icon when in watchlist', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetail,
          recommendations: [],
          isInWatchlist: true,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: true,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('taps watchlist button and dispatches event', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetail,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: false,
          ),
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: true,
            message: 'Added to Watchlist',
          ),
        ]),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => mockBloc.add(ToggleWatchlistEvent())).called(1);
    });

    testWidgets('renders seasons when available', (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetailWithSeasons,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetailWithSeasons,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      when(
            () => mockGetSeasonDetail.execute(any(), any()),
      ).thenAnswer((_) async => Right(tSeasonDetail));

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Seasons'), findsOneWidget);
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Episodes: 10'), findsOneWidget);
    });

    testWidgets('renders empty state when detail is null', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: null,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: null,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders with empty genres', (WidgetTester tester) async {
      const tvNoGenres = TvDetail(
        genres: [],
        id: 1,
        overview: 'overview',
        posterPath: '/posterPath',
        name: 'Test TV',
        voteAverage: 8.5,
        seasons: [],
      );

      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tvNoGenres,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tvNoGenres,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Test TV'), findsOneWidget);
      // Empty genre string should render
    });

    testWidgets('taps back button', (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetail,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
    });

    testWidgets('expands season tile and loads episodes', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetailWithSeasons,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetailWithSeasons,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      when(
            () => mockGetSeasonDetail.execute(any(), any()),
      ).thenAnswer((_) async => Right(tSeasonDetail));

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      // Find and tap the ExpansionTile
      final expansionTile = find.byType(ExpansionTile);
      expect(expansionTile, findsOneWidget);

      await tester.ensureVisible(expansionTile);
      await tester.tap(expansionTile);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => mockGetSeasonDetail.execute(any(), any())).called(1);

      // Episode should be displayed after expansion
      expect(find.text('1. Episode 1'), findsOneWidget);
    });

    testWidgets('renders episodes with null stillPath', (
        WidgetTester tester,
        ) async {
      final seasonWithNullStillPath = SeasonDetail(
        id: 101,
        seasonNumber: 1,
        episodes: [
          Episode(
            id: 1001,
            name: 'Episode No Image',
            episodeNumber: 1,
            overview: 'Episode without image',
            stillPath: null, // No image
          ),
        ],
      );

      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetailWithSeasons,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetailWithSeasons,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      when(
            () => mockGetSeasonDetail.execute(any(), any()),
      ).thenAnswer((_) async => Right(seasonWithNullStillPath));

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      // Expand season
      final expansionTile = find.byType(ExpansionTile);
      await tester.ensureVisible(expansionTile);
      await tester.tap(expansionTile);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => mockGetSeasonDetail.execute(any(), any())).called(1);

      // Episode with null stillPath should show SizedBox instead
      expect(find.text('1. Episode No Image'), findsOneWidget);
    });

    testWidgets('renders season with null posterPath', (
        WidgetTester tester,
        ) async {
      const tvWithNullSeasonPoster = TvDetail(
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        overview: 'overview',
        posterPath: '/posterPath',
        name: 'Test TV',
        voteAverage: 8.5,
        seasons: [
          Season(
            id: 101,
            name: 'Season 1',
            episodeCount: 10,
            seasonNumber: 1,
            posterPath: null, // No poster
          ),
        ],
      );

      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tvWithNullSeasonPoster,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tvWithNullSeasonPoster,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      // Season with null posterPath should still display
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Episodes: 10'), findsOneWidget);
    });

    testWidgets('renders seasons list with separator', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetailWithMultipleSeasons,
          recommendations: [],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetailWithMultipleSeasons,
            recommendations: [],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('taps recommendation and navigates', (
        WidgetTester tester,
        ) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tTvDetail,
          recommendations: [tTv],
          isInWatchlist: false,
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
            (_) => Stream.value(
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [tTv],
            isInWatchlist: false,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      final recommendationCard = find.byType(InkWell).first;
      await tester.ensureVisible(recommendationCard);
      await tester.tap(recommendationCard);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
