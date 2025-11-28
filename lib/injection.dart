import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton_core/core/db/database_helper.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_remote_data_source.dart';
// movie repo imports
import 'package:ditonton_movies/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
// movie usecases
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/save_watchlist.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_detail_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/top_rated_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/popular_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/top_rated_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_list_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_search_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/watchlist_tv_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(ThemeModeNotifier.new);
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  // TV providers
  locator.registerFactory(
    () => TvListNotifier(
      getOnTheAirTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
      getAiringTodayTv: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchlistStatusTv: locator(),
      saveWatchlistTv: locator(),
      removeWatchlistTv: locator(),
      getSeasonDetail: locator(),
    ),
  );
  locator.registerFactory(() => TvSearchNotifier(searchTv: locator()));
  locator.registerFactory(() => PopularTvNotifier(locator()));
  locator.registerFactory(() => TopRatedTvNotifier(getTopRatedTv: locator()));
  locator.registerFactory(
    () => WatchlistTvNotifier(
      getWatchlistTv: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // TV use cases
  locator.registerLazySingleton(() => GetOnTheAirTv(locator()));
  locator.registerLazySingleton(() => GetAiringTodayTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(DatabaseHelper.new);

  // external
  locator.registerLazySingleton(http.Client.new);
}
