import 'dart:convert';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvModel', () {
    final tTvModel = TvModel(
      id: 1,
      name: 'Name',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
    );

    test('should be a subclass of Tv entity', () {
      final result = tTvModel.toEntity();
      expect(result, isA<Tv>());
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
      };

      final result = TvModel.fromJson(json);

      expect(result, equals(tTvModel));
    });

    test('fromJson should handle missing name', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'original_name': 'Original Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
      };

      final result = TvModel.fromJson(json);

      expect(result.name, equals('Original Name'));
    });

    test('fromJson should handle missing overview', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
      };

      final result = TvModel.fromJson(json);

      expect(result.overview, equals(''));
    });

    test('fromJson should handle missing vote_average', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
      };

      final result = TvModel.fromJson(json);

      expect(result.voteAverage, equals(0.0));
    });

    test('toJson should return a valid JSON map', () {
      final result = tTvModel.toJson();

      final expectedMap = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.0,
      };

      expect(result, equals(expectedMap));
    });

    test('toEntity should return a valid Tv entity', () {
      final result = tTvModel.toEntity();

      const expected = Tv(
        id: 1,
        name: 'Name',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.0,
      );

      expect(result, equals(expected));
    });

    test('props should contain all fields', () {
      expect(tTvModel.props, equals([1, 'Name', 'Overview', '/path.jpg', 8.0]));
    });
  });

  group('TvResponse', () {
    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'results': [
          {
            'id': 1,
            'name': 'Name',
            'overview': 'Overview',
            'poster_path': '/path.jpg',
            'vote_average': 8.0,
          },
        ],
      };

      final result = TvResponse.fromJson(json);

      expect(result.tvList.length, 1);
      expect(result.tvList[0].id, 1);
    });

    test('props should contain tvList', () {
      const response = TvResponse(tvList: []);
      expect(response.props, equals([const <TvModel>[]]));
    });
  });

  group('SeasonModel', () {
    const tSeasonModel = SeasonModel(
      id: 1,
      seasonNumber: 1,
      name: 'Season 1',
      posterPath: '/path.jpg',
      episodeCount: 10,
    );

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'season_number': 1,
        'name': 'Season 1',
        'poster_path': '/path.jpg',
        'episode_count': 10,
      };

      final result = SeasonModel.fromJson(json);

      expect(result, equals(tSeasonModel));
    });

    test('fromJson should handle missing fields', () {
      final Map<String, dynamic> json = {'id': 1, 'poster_path': '/path.jpg'};

      final result = SeasonModel.fromJson(json);

      expect(result.seasonNumber, equals(0));
      expect(result.name, equals(''));
      expect(result.episodeCount, equals(0));
    });

    test('toEntity should return a valid Season entity', () {
      final result = tSeasonModel.toEntity();

      const expected = Season(
        id: 1,
        seasonNumber: 1,
        name: 'Season 1',
        posterPath: '/path.jpg',
        episodeCount: 10,
      );

      expect(result, equals(expected));
    });

    test('props should contain all fields', () {
      expect(tSeasonModel.props, equals([1, 1, 'Season 1', '/path.jpg', 10]));
    });
  });

  group('Episode Model', () {
    const tEpisodeModel = EpisodeModel(
      id: 1,
      name: 'Episode 1',
      episodeNumber: 1,
      overview: 'Overview',
      stillPath: '/path.jpg',
    );

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'Episode 1',
        'episode_number': 1,
        'overview': 'Overview',
        'still_path': '/path.jpg',
      };

      final result = EpisodeModel.fromJson(json);

      expect(result, equals(tEpisodeModel));
    });

    test('fromJson should handle missing fields', () {
      final Map<String, dynamic> json = {'id': 1, 'still_path': '/path.jpg'};

      final result = EpisodeModel.fromJson(json);

      expect(result.name, equals(''));
      expect(result.episodeNumber, equals(0));
      expect(result.overview, equals(''));
    });

    test('toEntity should return a valid Episode entity', () {
      final result = tEpisodeModel.toEntity();

      const expected = Episode(
        id: 1,
        name: 'Episode 1',
        episodeNumber: 1,
        overview: 'Overview',
        stillPath: '/path.jpg',
      );

      expect(result, equals(expected));
    });

    test('props should contain all fields', () {
      expect(
        tEpisodeModel.props,
        equals([1, 'Episode 1', 1, 'Overview', '/path.jpg']),
      );
    });
  });

  group('SeasonDetailResponse', () {
    const tSeasonDetailResponse = SeasonDetailResponse(
      id: 1,
      seasonNumber: 1,
      episodes: [],
    );

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'season_number': 1,
        'episodes': [],
      };

      final result = SeasonDetailResponse.fromJson(json);

      expect(result, equals(tSeasonDetailResponse));
    });

    test('fromJson should parse episodes', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'season_number': 1,
        'episodes': [
          {
            'id': 1,
            'name': 'Episode 1',
            'episode_number': 1,
            'overview': 'Overview',
            'still_path': '/path.jpg',
          },
        ],
      };

      final result = SeasonDetailResponse.fromJson(json);

      expect(result.episodes.length, 1);
      expect(result.episodes[0].id, 1);
    });

    test('fromJson should handle missing episodes', () {
      final Map<String, dynamic> json = {'id': 1, 'season_number': 1};

      final result = SeasonDetailResponse.fromJson(json);

      expect(result.episodes, equals([]));
    });

    test('fromJson should handle missing season_number', () {
      final Map<String, dynamic> json = {'id': 1, 'episodes': []};

      final result = SeasonDetailResponse.fromJson(json);

      expect(result.seasonNumber, equals(0));
    });

    test('toEntity should return a valid SeasonDetail entity', () {
      final result = tSeasonDetailResponse.toEntity();

      const expected = SeasonDetail(id: 1, seasonNumber: 1, episodes: []);

      expect(result, equals(expected));
    });

    test('props should contain all fields', () {
      expect(
        tSeasonDetailResponse.props,
        equals([1, 1, const <EpisodeModel>[]]),
      );
    });
  });
}
