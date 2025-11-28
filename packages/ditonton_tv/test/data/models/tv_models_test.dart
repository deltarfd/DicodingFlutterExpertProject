import 'dart:convert';

import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvModel & related models', () {
    test('TvModel.fromJson/toEntity', () {
      final jsonMap = {
        'id': 1,
        'name': 'Name',
        'overview': 'Overview',
        'poster_path': '/p',
        'vote_average': 7.0,
      };
      final model = TvModel.fromJson(jsonMap);
      expect(model.id, 1);
      final entity = model.toEntity();
      expect(entity.name, 'Name');
    });

    test('TvDetailResponse.fromJson/toEntity', () {
      final jsonStr = jsonEncode({
        'id': 99,
        'name': 'Detail',
        'overview': 'O',
        'poster_path': '/p',
        'vote_average': 9.0,
        'genres': [],
        'seasons': [
          {
            'id': 3,
            'season_number': 1,
            'name': 'S1',
            'poster_path': '/s',
            'episode_count': 10
          }
        ]
      });
      final detail = TvDetailResponse.fromJson(jsonDecode(jsonStr));
      expect(detail.id, 99);
      final entity = detail.toEntity();
      expect(entity.seasons.first.seasonNumber, 1);
    });

    test('SeasonDetailResponse.fromJson/toEntity', () {
      final jsonStr = jsonEncode({
        'id': 77,
        'season_number': 2,
        'episodes': [
          {
            'id': 100,
            'name': 'E1',
            'episode_number': 1,
            'overview': '...',
            'still_path': '/still'
          }
        ]
      });
      final season = SeasonDetailResponse.fromJson(jsonDecode(jsonStr));
      expect(season.seasonNumber, 2);
      final entity = season.toEntity();
      expect(entity.episodes.length, 1);
      expect(entity.episodes.first.episodeNumber, 1);
    });
  });
}
