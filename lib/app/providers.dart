import 'package:ditonton/app/shell_cubit.dart';
import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Factory class for creating app-wide BLoC providers
/// All state management uses BLoC pattern (no Provider/ChangeNotifier)
class AppProviders {
  /// Creates all BLoC providers for the app
  static List<BlocProvider> getBlocProviders() {
    return [
      // App-level
      BlocProvider<ShellCubit>(create: (_) => di.locator<ShellCubit>()),
      BlocProvider<ThemeModeCubit>(create: (_) => di.locator<ThemeModeCubit>()),

      // Movies
      BlocProvider<NowPlayingMoviesBloc>(
        create: (_) => di.locator<NowPlayingMoviesBloc>(),
      ),
      BlocProvider<PopularMoviesBloc>(
        create: (_) => di.locator<PopularMoviesBloc>(),
      ),
      BlocProvider<TopRatedMoviesBloc>(
        create: (_) => di.locator<TopRatedMoviesBloc>(),
      ),
      BlocProvider<MovieDetailBloc>(
        create: (_) => di.locator<MovieDetailBloc>(),
      ),
      BlocProvider<WatchlistMovieBloc>(
        create: (_) => di.locator<WatchlistMovieBloc>(),
      ),
      BlocProvider<MovieSearchBloc>(
        create: (_) => di.locator<MovieSearchBloc>(),
      ),
      BlocProvider<SearchRecentCubit>(
        create: (_) => di.locator<SearchRecentCubit>(),
      ),

      // TV Series
      BlocProvider<OnTheAirTvBloc>(
        create: (_) => di.locator<OnTheAirTvBloc>(),
      ),
      BlocProvider<AiringTodayTvBloc>(
        create: (_) => di.locator<AiringTodayTvBloc>(),
      ),
      BlocProvider<PopularTvBloc>(create: (_) => di.locator<PopularTvBloc>()),
      BlocProvider<TopRatedTvBloc>(create: (_) => di.locator<TopRatedTvBloc>()),
      BlocProvider<TvDetailBloc>(create: (_) => di.locator<TvDetailBloc>()),
      BlocProvider<TvSearchBloc>(create: (_) => di.locator<TvSearchBloc>()),
      BlocProvider<TvSearchRecentCubit>(
          create: (_) => di.locator<TvSearchRecentCubit>()),
      BlocProvider<WatchlistTvBloc>(
        create: (_) => di.locator<WatchlistTvBloc>(),
      ),
    ];
  }
}
