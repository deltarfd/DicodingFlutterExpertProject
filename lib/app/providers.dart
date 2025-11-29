import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
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
    ];
  }

  /// Creates all BLoC providers for the app
  static List<SingleChildWidget> getBlocProviders() {
    return [
      // Movies
      BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
      BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
      BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
      BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
      BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
      BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),

      // TV Series
      BlocProvider(create: (_) => di.locator<OnTheAirTvBloc>()),
      BlocProvider(create: (_) => di.locator<AiringTodayTvBloc>()),
      BlocProvider(create: (_) => di.locator<PopularTvBloc>()),
      BlocProvider(create: (_) => di.locator<TopRatedTvBloc>()),
      BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
      BlocProvider(create: (_) => di.locator<TvSearchBloc>()),
      BlocProvider(create: (_) => di.locator<WatchlistTvBloc>()),
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
