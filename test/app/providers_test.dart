import 'package:ditonton/app/providers.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  setUpAll(() {
    di.init();
  });

  group('AppProviders', () {
    test('should be instantiable', () {
      final providers = AppProviders();
      expect(providers, isNotNull);
    });

    test('getChangeNotifierProviders should return list of providers', () {
      final providers = AppProviders.getChangeNotifierProviders();
      expect(providers, isA<List<SingleChildWidget>>());
      expect(providers.length, 12);
    });

    test('getBlocProviders should return list of BLoC providers', () {
      final providers = AppProviders.getBlocProviders();
      expect(providers, isA<List<SingleChildWidget>>());
      expect(providers.length, 7);
    });

    test('getAllProviders should combine both provider types', () {
      final providers = AppProviders.getAllProviders();
      expect(providers, isA<List<SingleChildWidget>>());
      expect(providers.length, 19);
    });

    testWidgets('should initialize all providers correctly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: AppProviders.getAllProviders(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                // Trigger creation of all providers
                context.read<ThemeModeNotifier>();
                context.read<MovieListNotifier>();
                context.read<MovieDetailNotifier>();
                context.read<TopRatedMoviesNotifier>();
                context.read<PopularMoviesNotifier>();
                context.read<WatchlistMovieNotifier>();

                context.read<TvListNotifier>();
                context.read<TvDetailNotifier>();
                context.read<TvSearchNotifier>();
                context.read<TopRatedTvNotifier>();
                context.read<PopularTvNotifier>();
                context.read<WatchlistTvNotifier>();

                context.read<OnTheAirTvBloc>();
                context.read<AiringTodayTvBloc>();
                context.read<PopularTvBloc>();
                context.read<TopRatedTvBloc>();
                context.read<TvDetailBloc>();
                context.read<TvSearchBloc>();
                context.read<MovieSearchBloc>();

                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
