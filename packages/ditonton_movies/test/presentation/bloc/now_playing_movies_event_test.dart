import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Now Playing Movies Events', () {
    test('FetchNowPlayingMovies should have correct props', () {
      expect(FetchNowPlayingMovies().props, []);
    });

    test('FetchNowPlayingMovies instances should be equal', () {
      expect(FetchNowPlayingMovies(), equals(FetchNowPlayingMovies()));
    });
  });
}
