import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:ditonton_tv/features/tv/data/models/genre_model.dart';

void main() {
  group('TvModel & Detail & Season/Episode mapping', () {
    test('TvModel fromJson/toJson/toEntity', () {
      final json = {
        'id': 10,
        'name': null,
        'original_name': 'Orig',
        'overview': null,
        'poster_path': '/p.jpg',
        'vote_average': 7,
      };
      final m = TvModel.fromJson(json);
      expect(m.name, 'Orig');
      expect(m.overview, '');
      expect(m.toJson()['name'], 'Orig');
      final e = m.toEntity();
      expect(e.name, 'Orig');
    });

    test('TvDetailResponse fromJson -> entity contains genres & seasons', () {
      final json = {
        'id': 1,
        'name': 'N',
        'overview': 'O',
        'poster_path': '/a.jpg',
        'vote_average': 8.5,
        'genres': [
          {'id': 1, 'name': 'Action'}
        ],
        'seasons': [
          {
            'id': 9,
            'season_number': 2,
            'name': 'S2',
            'poster_path': null,
            'episode_count': 12,
          }
        ]
      };
      final d = TvDetailResponse.fromJson(json);
      final ent = d.toEntity();
      expect(ent.genres.first.name, 'Action');
      expect(ent.seasons.first.seasonNumber, 2);
    });

    test('Episode & SeasonDetailResponse mapping', () {
      final json = {
        'id': 5,
        'season_number': 1,
        'episodes': [
          {
            'id': 7,
            'name': 'E1',
            'episode_number': 1,
            'overview': '...'
          }
        ]
      };
      final sd = SeasonDetailResponse.fromJson(json);
      final ent = sd.toEntity();
      expect(ent.episodes.first.episodeNumber, 1);
      expect(ent.seasonNumber, 1);
    });
  });
}
