import 'package:ditonton_movies/features/movies/data/models/movie_table.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MovieTable.fromEntity and toEntity work as expected', () {
    const detail = MovieDetail(
      adult: false,
      backdropPath: 'b',
      genres: [],
      id: 42,
      originalTitle: 'OT',
      overview: 'OV',
      posterPath: '/p',
      releaseDate: '2020-01-01',
      runtime: 100,
      title: 'T',
      voteAverage: 7.0,
      voteCount: 10,
    );
    final table = MovieTable.fromEntity(detail);
    expect(table.id, 42);
    expect(table.title, 'T');
    expect(table.posterPath, '/p');
    expect(table.overview, 'OV');

    final entity = table.toEntity();
    expect(entity, isA<Movie>());
    expect(entity.id, 42);
    expect(entity.title, 'T');
  });

  test('MovieTable.fromMap and toJson round-trip', () {
    final map = {
      'id': 7,
      'title': 'X',
      'posterPath': '/x',
      'overview': 'Y',
    };
    final table = MovieTable.fromMap(map);
    expect(table.id, 7);
    expect(table.title, 'X');
    expect(table.posterPath, '/x');
    expect(table.overview, 'Y');

    final json = table.toJson();
    expect(json['id'], 7);
    expect(json['title'], 'X');
    expect(json['posterPath'], '/x');
    expect(json['overview'], 'Y');
  });
}