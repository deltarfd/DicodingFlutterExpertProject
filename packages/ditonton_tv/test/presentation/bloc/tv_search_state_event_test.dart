import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvSearchEvent', () {
    group('SubmitTvQuery', () {
      test('supports value equality', () {
        expect(
          const SubmitTvQuery('query'),
          equals(const SubmitTvQuery('query')),
        );
      });

      test('props are correct', () {
        const event = SubmitTvQuery('test query');
        expect(event.props, equals(['test query']));
      });
    });

    group('ClearTvQuery', () {
      test('supports value equality', () {
        expect(const ClearTvQuery(), equals(const ClearTvQuery()));
      });

      test('props are correct', () {
        const event = ClearTvQuery();
        expect(event.props, equals([]));
      });
    });
  });

  group('TvSearchState', () {
    test('TvSearchInitial supports value equality', () {
      expect(TvSearchInitial(), equals(TvSearchInitial()));
    });

    test('TvSearchLoading supports value equality', () {
      expect(TvSearchLoading(), equals(TvSearchLoading()));
    });

    test('TvSearchLoaded supports value equality', () {
      expect(const TvSearchLoaded([]), equals(const TvSearchLoaded([])));
    });

    test('TvSearchError supports value equality', () {
      expect(
        const TvSearchError('error'),
        equals(const TvSearchError('error')),
      );
    });

    test('TvSearchLoaded props are correct', () {
      const tTv = Tv(
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        voteAverage: 1.0,
      );
      expect(
        const TvSearchLoaded([tTv]).props,
        equals([
          [tTv],
        ]),
      );
    });

    test('TvSearchError props are correct', () {
      expect(const TvSearchError('error').props, equals(['error']));
    });
  });
}
