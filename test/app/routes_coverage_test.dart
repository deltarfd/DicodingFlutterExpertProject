import 'package:ditonton/app/routes.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart'
    as m;
import 'package:ditonton_tv/features/tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/on_the_air_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/airing_today_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onGenerateRoute returns non-null routes for known names', () {
    final names = <RouteSettings>[
      const RouteSettings(name: '/home'),
      const RouteSettings(name: PopularMoviesPage.routeName),
      const RouteSettings(name: TopRatedMoviesPage.routeName),
      const RouteSettings(name: MovieDetailPage.routeName, arguments: 1),
      const RouteSettings(name: m.SearchPage.routeName),
      const RouteSettings(name: WatchlistMoviesPage.routeName),
      const RouteSettings(name: HomeTvPage.routeName),
      const RouteSettings(name: PopularTvPage.routeName),
      const RouteSettings(name: TopRatedTvPage.routeName),
      const RouteSettings(name: OnTheAirTvPage.routeName),
      const RouteSettings(name: AiringTodayTvPage.routeName),
      const RouteSettings(name: TvDetailPage.routeName, arguments: 1),
      const RouteSettings(name: TvSearchPage.routeName),
      const RouteSettings(name: WatchlistTvPage.routeName),
      const RouteSettings(name: '/about'),
    ];

    for (final s in names) {
      final r = AppRoutes.onGenerateRoute(s);
      expect(r, isA<Route<dynamic>>());
    }
  });

  test('onGenerateRoute returns fallback for unknown route', () {
    final route = AppRoutes.onGenerateRoute(
      const RouteSettings(name: '/unknown-route'),
    );
    expect(route, isA<MaterialPageRoute>());
  });
}
