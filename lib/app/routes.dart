import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/airing_today_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/on_the_air_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_search_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeMoviePage());
      case PopularMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const PopularMoviesPage());
      case TopRatedMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const TopRatedMoviesPage());
      case MovieDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(id: id),
          settings: settings,
        );
      case SearchPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const SearchPage());
      case WatchlistMoviesPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => const WatchlistMoviesPage());
      // TV routes
      case HomeTvPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => const HomeTvPage());
      case PopularTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const PopularTvPage());
      case TopRatedTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const TopRatedTvPage());
      case OnTheAirTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const OnTheAirTvPage());
      case AiringTodayTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const AiringTodayTvPage());
      case TvDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TvDetailPage(id: id),
          settings: settings,
        );
      case TvSearchPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const TvSearchPage());
      case WatchlistTvPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => const WatchlistTvPage());
      case AboutPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('Page not found :(')),
          );
        });
    }
  }
}
