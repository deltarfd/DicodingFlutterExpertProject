import 'package:ditonton/app/providers.dart';
import 'package:ditonton/app/theme_mode_cubit.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockThemeModeCubit extends Mock implements ThemeModeCubit {}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await di.locator.reset();
    // Initialize real DI to test that providers can actually resolve dependencies
    di.init();
  });

  tearDown(() async {
    await di.locator.reset();
  });

  testWidgets('AppProviders.getBlocProviders creates all blocs correctly', (
    tester,
  ) async {
    // Act
    final providers = AppProviders.getBlocProviders();

    // Assert
    expect(providers.length, 14);

    // Verify each provider's create function works
    // We can't easily invoke create() directly because it's internal to BlocProvider
    // But we can pump a widget that uses these providers

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: providers,
        child: Builder(
          builder: (context) {
            // Trigger creation of all BLoCs
            context.read<ThemeModeCubit>();
            context.read<NowPlayingMoviesBloc>();
            context.read<PopularMoviesBloc>();
            context.read<TopRatedMoviesBloc>();
            context.read<MovieDetailBloc>();
            context.read<WatchlistMovieBloc>();
            context.read<MovieSearchBloc>();

            context.read<OnTheAirTvBloc>();
            context.read<AiringTodayTvBloc>();
            context.read<PopularTvBloc>();
            context.read<TopRatedTvBloc>();
            context.read<TvDetailBloc>();
            context.read<TvSearchBloc>();
            context.read<WatchlistTvBloc>();

            return const SizedBox();
          },
        ),
      ),
    );
  });
}
