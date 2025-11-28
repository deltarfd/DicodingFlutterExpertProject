import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_movies/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton_movies/features/movies/data/models/genre_model.dart';

void main() {
  test('MovieDetailResponse toJson covers all fields', () {
    final m = MovieDetailResponse(
      adult: false,
      backdropPath: '/b.jpg',
      budget: 100,
      genres: const [GenreModel(id: 1, name: 'Action')],
      homepage: 'h',
      id: 1,
      imdbId: 'tt',
      originalLanguage: 'en',
      originalTitle: 'OT',
      overview: 'O',
      popularity: 1.2,
      posterPath: '/p.jpg',
      releaseDate: '2020-01-01',
      revenue: 200,
      runtime: 120,
      status: 'Released',
      tagline: 'T',
      title: 'Title',
      video: false,
      voteAverage: 8.0,
      voteCount: 10,
    );
    final j = m.toJson();
    expect(j['adult'], false);
    expect(j['genres'][0]['name'], 'Action');
    expect(j['vote_average'], 8.0);
  });
}
