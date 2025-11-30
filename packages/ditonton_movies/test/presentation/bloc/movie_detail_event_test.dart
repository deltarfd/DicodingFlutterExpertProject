import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Movie Detail Events', () {
    final tMovieDetail = MovieDetail(
      adult: false,
      backdropPath: '/path.jpg',
      genres: [],
      id: 1,
      originalTitle: 'Test',
      overview: 'Test overview',
      posterPath: '/poster.jpg',
      releaseDate: '2020-01-01',
      runtime: 120,
      title: 'Test Movie',
      voteAverage: 8.0,
      voteCount: 100,
    );

    group('MovieDetailEvent base class', () {
      test('should have empty props', () {
        final event = _TestMovieDetailEvent();
        expect(event.props, []);
      });
    });

    group('FetchMovieDetail', () {
      test('should have correct props', () {
        final event = FetchMovieDetail(1);
        expect(event.props, [1]);
      });

      test('instances with same id should be equal', () {
        expect(FetchMovieDetail(1), equals(FetchMovieDetail(1)));
      });

      test('instances with different id should not be equal', () {
        expect(FetchMovieDetail(1), isNot(equals(FetchMovieDetail(2))));
      });
    });

    group('AddWatchlist', () {
      test('should have correct props', () {
        final event = AddWatchlist(tMovieDetail);
        expect(event.props, [tMovieDetail]);
      });

      test('instances with same movie should be equal', () {
        expect(
          AddWatchlist(tMovieDetail),
          equals(AddWatchlist(tMovieDetail)),
        );
      });
    });

    group('RemoveFromWatchlist', () {
      test('should have correct props', () {
        final event = RemoveFromWatchlist(tMovieDetail);
        expect(event.props, [tMovieDetail]);
      });

      test('instances with same movie should be equal', () {
        expect(
          RemoveFromWatchlist(tMovieDetail),
          equals(RemoveFromWatchlist(tMovieDetail)),
        );
      });
    });

    group('LoadWatchlistStatus', () {
      test('should have correct props', () {
        final event = LoadWatchlistStatus(1);
        expect(event.props, [1]);
      });

      test('instances with same id should be equal', () {
        expect(LoadWatchlistStatus(1), equals(LoadWatchlistStatus(1)));
      });

      test('instances with different id should not be equal', () {
        expect(LoadWatchlistStatus(1), isNot(equals(LoadWatchlistStatus(2))));
      });
    });
  });
}

// Test implementation of abstract class
class _TestMovieDetailEvent extends MovieDetailEvent {
  const _TestMovieDetailEvent();
}
