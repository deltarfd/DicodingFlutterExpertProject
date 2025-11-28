import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeasonDetail', () {
    const tSeasonDetail = SeasonDetail(id: 1, seasonNumber: 1, episodes: []);

    test('should be a subclass of Equatable', () {
      expect(tSeasonDetail, isA<Object>());
    });

    test('props are correct', () {
      expect(tSeasonDetail.props, equals([1, 1, const <Episode>[]]));
    });

    test('supports value equality', () {
      expect(
        const SeasonDetail(id: 1, seasonNumber: 1, episodes: []),
        equals(const SeasonDetail(id: 1, seasonNumber: 1, episodes: [])),
      );
    });
  });
}
