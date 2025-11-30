import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Watchlist Movie Events', () {
    test('FetchWatchlistMovies should have correct props', () {
      expect(FetchWatchlistMovies().props, []);
    });

    test('FetchWatchlistMovies instances should be equal', () {
      expect(FetchWatchlistMovies(), equals(FetchWatchlistMovies()));
    });
  });
}
