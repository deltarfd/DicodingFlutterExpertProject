import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Popular Movies Events', () {
    test('FetchPopularMovies should have correct props', () {
      expect(FetchPopularMovies().props, []);
    });

    test('FetchPopularMovies instances should be equal', () {
      expect(FetchPopularMovies(), equals(FetchPopularMovies()));
    });
  });
}
