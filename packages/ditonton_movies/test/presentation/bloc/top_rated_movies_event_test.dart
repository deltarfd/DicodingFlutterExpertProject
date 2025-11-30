import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Top Rated Movies Events', () {
    test('FetchTopRatedMovies should have correct props', () {
      expect(FetchTopRatedMovies().props, []);
    });

    test('FetchTopRatedMovies instances should be equal', () {
      expect(FetchTopRatedMovies(), equals(FetchTopRatedMovies()));
    });
  });
}
