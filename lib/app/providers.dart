import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_detail_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/top_rated_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Factory class for creating app-wide providers
/// Extracted for testability and separation of concerns
class AppProviders {
  /// Creates all ChangeNotifier providers for the app
  static List<SingleChildWidget> getChangeNotifierProviders() {
    return [
      ChangeNotifierProvider(create: (_) => di.locator<ThemeModeNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<MovieDetailNotifier>()),
      ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>()),
      ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>()),
      ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<TvListNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<TvDetailNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<TvSearchNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<TopRatedTvNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<PopularTvNotifier>()),
      ChangeNotifierProvider(create: (_) => di.locator<WatchlistTvNotifier>()),
    ];
  }

  /// Creates all BLoC providers for the app
  static List<SingleChildWidget> getBlocProviders() {
    return [
      BlocProvider(create: (_) => OnTheAirTvBloc(getOnTheAirTv: di.locator())),
      BlocProvider(
          create: (_) => AiringTodayTvBloc(getAiringTodayTv: di.locator())),
      BlocProvider(create: (_) => PopularTvBloc(getPopularTv: di.locator())),
      BlocProvider(create: (_) => TopRatedTvBloc(getTopRatedTv: di.locator())),
      BlocProvider(
        create: (_) => TvDetailBloc(
          getTvDetail: di.locator(),
          getTvRecommendations: di.locator(),
          getWatchlistStatusTv: di.locator(),
          saveWatchlistTv: di.locator(),
          removeWatchlistTv: di.locator(),
        ),
      ),
      BlocProvider(create: (_) => TvSearchBloc(searchTv: di.locator())),
      BlocProvider(create: (_) => MovieSearchBloc(searchMovies: di.locator())),
    ];
  }

  /// Creates all providers for the app (both ChangeNotifier and BLoC)
  static List<SingleChildWidget> getAllProviders() {
    return [
      ...getChangeNotifierProviders(),
      ...getBlocProviders(),
    ];
  }
}
