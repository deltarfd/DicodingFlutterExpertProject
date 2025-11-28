import 'dart:convert';

import 'package:ditonton_movies/features/movies/data/models/movie_model.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MovieModel toJson/fromJson roundtrip', () {
    const model = MovieModel(
      adult: false,
      backdropPath: '/b',
      genreIds: [1, 2],
      id: 1,
      originalTitle: 'OT',
      overview: 'OV',
      popularity: 3.5,
      posterPath: '/p',
      releaseDate: '2020-01-01',
      title: 'T',
      video: false,
      voteAverage: 8.0,
      voteCount: 100,
    );
    final jsonMap = model.toJson();
    final from = MovieModel.fromJson(json.decode(json.encode(jsonMap)));
    expect(from.id, model.id);
    expect(from.title, model.title);
    expect(from.genreIds, model.genreIds);
    expect(from.voteAverage, model.voteAverage);
  });

  test('MovieModel.toEntity maps correctly', () {
    const model = MovieModel(
      adult: true,
      backdropPath: null,
      genreIds: [],
      id: 9,
      originalTitle: 'O',
      overview: 'OV',
      popularity: 1.0,
      posterPath: null,
      releaseDate: null,
      title: 'T',
      video: false,
      voteAverage: 5.0,
      voteCount: 1,
    );
    final entity = model.toEntity();
    expect(entity, isA<Movie>());
    expect(entity.id, 9);
    expect(entity.title, 'T');
    expect(entity.genreIds, []);
  });

  test('should be a subclass of Movie entity', () async {
    const tMovieModel = MovieModel(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );
    const tMovie = Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });
}
