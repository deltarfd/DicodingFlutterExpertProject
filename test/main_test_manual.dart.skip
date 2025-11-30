import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton/main.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_detail_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/top_rated_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/popular_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/top_rated_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_list_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_search_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/watchlist_tv_notifier.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/injection.dart' as di;

// Mocks
class MockThemeModeNotifier extends Mock implements ThemeModeNotifier {}

class MockMovieListNotifier extends Mock implements MovieListNotifier {}

class MockMovieDetailNotifier extends Mock implements MovieDetailNotifier {}

class MockTopRatedMoviesNotifier extends Mock
    implements TopRatedMoviesNotifier {}

class MockPopularMoviesNotifier extends Mock implements PopularMoviesNotifier {}

class MockWatchlistMovieNotifier extends Mock
    implements WatchlistMovieNotifier {}

class MockTvListNotifier extends Mock implements TvListNotifier {}

class MockTvDetailNotifier extends Mock implements TvDetailNotifier {}

class MockTvSearchNotifier extends Mock implements TvSearchNotifier {}

class MockTopRatedTvNotifier extends Mock implements TopRatedTvNotifier {}

class MockPopularTvNotifier extends Mock implements PopularTvNotifier {}

class MockWatchlistTvNotifier extends Mock implements WatchlistTvNotifier {
  @override
  RequestState get watchlistState => super.noSuchMethod(
    Invocation.getter(#watchlistState),
    returnValue: RequestState.Empty,
  );
}

class MockGetOnTheAirTv extends Mock implements GetOnTheAirTv {}

class MockGetAiringTodayTv extends Mock implements GetAiringTodayTv {}

class MockGetPopularTv extends Mock implements GetPopularTv {}

class MockGetTopRatedTv extends Mock implements GetTopRatedTv {}

class MockGetTvDetail extends Mock implements GetTvDetail {}

class MockGetTvRecommendations extends Mock implements GetTvRecommendations {}

class MockGetWatchlistStatusTv extends Mock implements GetWatchlistStatusTv {}

class MockGetWatchlistTv extends Mock implements GetWatchlistTv {}

class MockSaveWatchlistTv extends Mock implements SaveWatchlistTv {}

class MockRemoveWatchlistTv extends Mock implements RemoveWatchlistTv {}

class MockSearchTv extends Mock implements SearchTv {}

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MockThemeModeNotifier mockThemeModeNotifier;
  late MockMovieListNotifier mockMovieListNotifier;
  late MockMovieDetailNotifier mockMovieDetailNotifier;
  late MockTopRatedMoviesNotifier mockTopRatedMoviesNotifier;
  late MockPopularMoviesNotifier mockPopularMoviesNotifier;
  late MockWatchlistMovieNotifier mockWatchlistMovieNotifier;
  late MockTvListNotifier mockTvListNotifier;
  late MockTvDetailNotifier mockTvDetailNotifier;
  late MockTvSearchNotifier mockTvSearchNotifier;
  late MockTopRatedTvNotifier mockTopRatedTvNotifier;
  late MockPopularTvNotifier mockPopularTvNotifier;
  late MockWatchlistTvNotifier mockWatchlistTvNotifier;

  setUp(() {
    final locator = GetIt.instance;
    locator.reset();

    mockThemeModeNotifier = MockThemeModeNotifier();
    mockMovieListNotifier = MockMovieListNotifier();
    mockMovieDetailNotifier = MockMovieDetailNotifier();
    mockTopRatedMoviesNotifier = MockTopRatedMoviesNotifier();
    mockPopularMoviesNotifier = MockPopularMoviesNotifier();
    mockWatchlistMovieNotifier = MockWatchlistMovieNotifier();
    mockTvListNotifier = MockTvListNotifier();
    mockTvDetailNotifier = MockTvDetailNotifier();
    mockTvSearchNotifier = MockTvSearchNotifier();
    mockTopRatedTvNotifier = MockTopRatedTvNotifier();
    mockPopularTvNotifier = MockPopularTvNotifier();
    mockWatchlistTvNotifier = MockWatchlistTvNotifier();

    // Default stubs
    when(() => mockThemeModeNotifier.themeMode).thenReturn(ThemeMode.light);

    // MovieListNotifier stubs
    when(
      () => mockMovieListNotifier.fetchNowPlayingMovies(),
    ).thenAnswer((_) async {});
    when(
      () => mockMovieListNotifier.fetchPopularMovies(),
    ).thenAnswer((_) async {});
    when(
      () => mockMovieListNotifier.fetchTopRatedMovies(),
    ).thenAnswer((_) async {});
    when(
      () => mockMovieListNotifier.nowPlayingState,
    ).thenReturn(RequestState.Empty);
    when(
      () => mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.Empty);
    when(
      () => mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.Empty);
    when(() => mockMovieListNotifier.nowPlayingMovies).thenReturn([]);
    when(() => mockMovieListNotifier.popularMovies).thenReturn([]);
    when(() => mockMovieListNotifier.topRatedMovies).thenReturn([]);

    // TvListNotifier stubs
    when(() => mockTvListNotifier.fetchNowPlayingTv()).thenAnswer((_) async {});
    when(() => mockTvListNotifier.fetchPopularTv()).thenAnswer((_) async {});
    when(() => mockTvListNotifier.fetchTopRatedTv()).thenAnswer((_) async {});
    when(() => mockTvListNotifier.fetchOnTheAirTv()).thenAnswer((_) async {});
    when(
      () => mockTvListNotifier.fetchAiringTodayTv(),
    ).thenAnswer((_) async {});

    when(
      () => mockTvListNotifier.nowPlayingState,
    ).thenReturn(RequestState.Empty);
    when(() => mockTvListNotifier.popularState).thenReturn(RequestState.Empty);
    when(() => mockTvListNotifier.topRatedState).thenReturn(RequestState.Empty);
    when(() => mockTvListNotifier.onTheAirState).thenReturn(RequestState.Empty);
    when(
      () => mockTvListNotifier.airingTodayState,
    ).thenReturn(RequestState.Empty);

    when(() => mockTvListNotifier.nowPlayingTv).thenReturn([]);
    when(() => mockTvListNotifier.popularTv).thenReturn([]);
    when(() => mockTvListNotifier.topRatedTv).thenReturn([]);
    when(() => mockTvListNotifier.onTheAir).thenReturn([]);
    when(() => mockTvListNotifier.airingToday).thenReturn([]);

    // WatchlistTvNotifier stubs
    when(
      () => mockWatchlistTvNotifier.fetchWatchlistTv(),
    ).thenAnswer((_) async {});
    // when(() => mockWatchlistTvNotifier.watchlistState).thenReturn(RequestState.Empty);
    when(() => mockWatchlistTvNotifier.watchlistTv).thenReturn([]);

    // Register mocks
    locator.registerFactory<ThemeModeNotifier>(() => mockThemeModeNotifier);
    locator.registerFactory<MovieListNotifier>(() => mockMovieListNotifier);
    locator.registerFactory<MovieDetailNotifier>(() => mockMovieDetailNotifier);
    locator.registerFactory<TopRatedMoviesNotifier>(
      () => mockTopRatedMoviesNotifier,
    );
    locator.registerFactory<PopularMoviesNotifier>(
      () => mockPopularMoviesNotifier,
    );
    locator.registerFactory<WatchlistMovieNotifier>(
      () => mockWatchlistMovieNotifier,
    );
    locator.registerFactory<TvListNotifier>(() => mockTvListNotifier);
    locator.registerFactory<TvDetailNotifier>(() => mockTvDetailNotifier);
    locator.registerFactory<TvSearchNotifier>(() => mockTvSearchNotifier);
    locator.registerFactory<TopRatedTvNotifier>(() => mockTopRatedTvNotifier);
    locator.registerFactory<PopularTvNotifier>(() => mockPopularTvNotifier);
    locator.registerFactory<WatchlistTvNotifier>(() => mockWatchlistTvNotifier);

    // Register Use Cases for Blocs
    locator.registerLazySingleton<GetOnTheAirTv>(() => MockGetOnTheAirTv());
    locator.registerLazySingleton<GetAiringTodayTv>(
      () => MockGetAiringTodayTv(),
    );
    locator.registerLazySingleton<GetPopularTv>(() => MockGetPopularTv());
    locator.registerLazySingleton<GetTopRatedTv>(() => MockGetTopRatedTv());
    locator.registerLazySingleton<GetTvDetail>(() => MockGetTvDetail());
    locator.registerLazySingleton<GetTvRecommendations>(
      () => MockGetTvRecommendations(),
    );
    locator.registerLazySingleton<GetWatchlistStatusTv>(
      () => MockGetWatchlistStatusTv(),
    );
    locator.registerLazySingleton<GetWatchlistTv>(() => MockGetWatchlistTv());
    locator.registerLazySingleton<SaveWatchlistTv>(() => MockSaveWatchlistTv());
    locator.registerLazySingleton<RemoveWatchlistTv>(
      () => MockRemoveWatchlistTv(),
    );
    locator.registerLazySingleton<SearchTv>(() => MockSearchTv());
    locator.registerLazySingleton<SearchMovies>(() => MockSearchMovies());
  });

  testWidgets('MyApp should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
