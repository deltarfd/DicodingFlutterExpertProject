import 'package:ditonton_tv/features/tv/data/models/genre_model.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvDetailModel', () {
    final tTvDetailModel = TvDetailResponse(
      id: 1,
      name: 'Name',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
      genres: [GenreModel(id: 1, name: 'Action')],
      seasons: [
        SeasonModel(
          id: 1,
          seasonNumber: 1,
          name: 'Season 1',
          posterPath: '/season.jpg',
          episodeCount: 10,
        ),
      ],
    );

    test('should be a subclass of TvDetail entity', () {
      final result = tTvDetailModel.toEntity();
      expect(result, isA<TvDetail>());
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
        'genres': [
          {'id': 1, 'name': 'Action'},
        ],
        'seasons': [
          {
            'id': 1,
            'season_number': 1,
            'name': 'Season 1',
            'poster_path': '/season.jpg',
            'episode_count': 10,
          },
        ],
      };

      final result = TvDetailResponse.fromJson(json);

      expect(result.id, 1);
      expect(result.name, 'Name');
      expect(result.genres.length, 1);
      expect(result.seasons.length, 1);
    });

    test('fromJson should handle missing name', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'original_name': 'Original Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
        'genres': [],
        'seasons': [],
      };

      final result = TvDetailResponse.fromJson(json);

      expect(result.name, equals('Original Name'));
    });

    test('fromJson should handle missing overview', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
        'genres': [],
        'seasons': [],
      };

      final result = TvDetailResponse.fromJson(json);

      expect(result.overview, equals(''));
    });

    test('fromJson should handle missing vote_average', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'genres': [],
        'seasons': [],
      };

      final result = TvDetailResponse.fromJson(json);

      expect(result.voteAverage, equals(0.0));
    });

    test('fromJson should handle missing genres', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
        'seasons': [],
      };

      final result = TvDetailResponse.fromJson(json);

      expect(result.genres, equals([]));
    });

    test('fromJson should handle missing seasons', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
        'genres': [],
      };

      final result = TvDetailResponse.fromJson(json);

      expect(result.seasons, equals([]));
    });

    test('toEntity should return a valid TvDetail entity', () {
      final result = tTvDetailModel.toEntity();

      expect(result.id, 1);
      expect(result.name, 'Name');
      expect(result.genres.length, 1);
      expect(result.seasons.length, 1);
    });

    test('props should contain all fields', () {
      const model = TvDetailResponse(
        id: 1,
        name: 'Name',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.0,
        genres: [],
        seasons: [],
      );

      expect(
        model.props,
        equals([
          1,
          'Name',
          'Overview',
          '/path.jpg',
          8.0,
          const <GenreModel>[],
          const <SeasonModel>[],
        ]),
      );
    });
  });
}
