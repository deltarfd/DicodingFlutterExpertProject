import 'package:ditonton/injection.dart' as di;
import 'package:ditonton_movies/features/movies/presentation/providers/movie_detail_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/top_rated_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_list_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_search_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/popular_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/top_rated_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('di resolves key factories/providers without throwing', () {
    di.init();

    // Movies providers
    expect(di.locator<MovieListNotifier>(), isA<MovieListNotifier>());
    expect(di.locator<MovieDetailNotifier>(), isA<MovieDetailNotifier>());
    expect(di.locator<PopularMoviesNotifier>(), isA<PopularMoviesNotifier>());
    expect(di.locator<TopRatedMoviesNotifier>(), isA<TopRatedMoviesNotifier>());
    expect(di.locator<WatchlistMovieNotifier>(), isA<WatchlistMovieNotifier>());

    // TV providers
    expect(di.locator<TvListNotifier>(), isA<TvListNotifier>());
    expect(di.locator<TvDetailNotifier>(), isA<TvDetailNotifier>());
    expect(di.locator<TvSearchNotifier>(), isA<TvSearchNotifier>());
    expect(di.locator<PopularTvNotifier>(), isA<PopularTvNotifier>());
    expect(di.locator<TopRatedTvNotifier>(), isA<TopRatedTvNotifier>());
    expect(di.locator<WatchlistTvNotifier>(), isA<WatchlistTvNotifier>());

    di.locator.reset();
  });
}
