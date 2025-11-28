import 'package:ditonton/app/routes.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart' as m;
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
      const RouteSettings(name: PopularMoviesPage.ROUTE_NAME),
      const RouteSettings(name: TopRatedMoviesPage.ROUTE_NAME),
      const RouteSettings(name: MovieDetailPage.ROUTE_NAME, arguments: 1),
      const RouteSettings(name: m.SearchPage.ROUTE_NAME),
      const RouteSettings(name: WatchlistMoviesPage.ROUTE_NAME),
      const RouteSettings(name: HomeTvPage.ROUTE_NAME),
      const RouteSettings(name: PopularTvPage.ROUTE_NAME),
      const RouteSettings(name: TopRatedTvPage.ROUTE_NAME),
      const RouteSettings(name: OnTheAirTvPage.ROUTE_NAME),
      const RouteSettings(name: AiringTodayTvPage.ROUTE_NAME),
      const RouteSettings(name: TvDetailPage.ROUTE_NAME, arguments: 1),
      const RouteSettings(name: TvSearchPage.ROUTE_NAME),
      const RouteSettings(name: WatchlistTvPage.ROUTE_NAME),
    ];

    for (final s in names) {
      final r = AppRoutes.onGenerateRoute(s);
      expect(r, isA<Route<dynamic>>());
    }
  });
}
