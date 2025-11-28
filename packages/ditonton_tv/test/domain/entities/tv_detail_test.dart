import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvDetail', () {
    const tTvDetail = TvDetail(
      id: 1,
      name: 'Name',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
      genres: [],
      seasons: [],
    );

    test('props are correct', () {
      expect(
        tTvDetail.props,
        equals([
          1,
          'Name',
          'Overview',
          '/path.jpg',
          8.0,
          const <Genre>[],
          const <Season>[],
        ]),
      );
    });

    test('supports value equality', () {
      const detail1 = TvDetail(
        id: 1,
        name: 'Name',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.0,
        genres: [],
        seasons: [],
      );

      const detail2 = TvDetail(
        id: 1,
        name: 'Name',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.0,
        genres: [],
        seasons: [],
      );

      expect(detail1, equals(detail2));
    });
  });

  group('Season', () {
    const tSeason = Season(
      id: 1,
      seasonNumber: 1,
      name: 'Season 1',
      posterPath: '/path.jpg',
      episodeCount: 10,
    );

    test('props are correct', () {
      expect(tSeason.props, equals([1, 1, 'Season 1', '/path.jpg', 10]));
    });

    test('supports value equality', () {
      const season1 = Season(
        id: 1,
        seasonNumber: 1,
        name: 'Season 1',
        posterPath: '/path.jpg',
        episodeCount: 10,
      );

      const season2 = Season(
        id: 1,
        seasonNumber: 1,
        name: 'Season 1',
        posterPath: '/path.jpg',
        episodeCount: 10,
      );

      expect(season1, equals(season2));
    });
  });
}
