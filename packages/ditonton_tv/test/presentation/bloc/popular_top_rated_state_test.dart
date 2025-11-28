import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PopularTvState', () {
    test('PopularTvInitial supports value equality', () {
      expect(PopularTvInitial(), equals(PopularTvInitial()));
    });

    test('PopularTvLoading supports value equality', () {
      expect(PopularTvLoading(), equals(PopularTvLoading()));
    });

    test('PopularTvLoaded supports value equality', () {
      expect(const PopularTvLoaded([]), equals(const PopularTvLoaded([])));
    });

    test('PopularTvError supports value equality', () {
      expect(
        const PopularTvError('error'),
        equals(const PopularTvError('error')),
      );
    });

    test('PopularTvLoaded props are correct', () {
      const tTv = Tv(
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        voteAverage: 1.0,
      );
      expect(
        const PopularTvLoaded([tTv]).props,
        equals([
          [tTv],
        ]),
      );
    });

    test('PopularTvError props are correct', () {
      expect(const PopularTvError('error').props, equals(['error']));
    });
  });

  group('TopRatedTvState', () {
    test('TopRatedTvInitial supports value equality', () {
      expect(TopRatedTvInitial(), equals(TopRatedTvInitial()));
    });

    test('TopRatedTvLoading supports value equality', () {
      expect(TopRatedTvLoading(), equals(TopRatedTvLoading()));
    });

    test('TopRatedTvLoaded supports value equality', () {
      expect(const TopRatedTvLoaded([]), equals(const TopRatedTvLoaded([])));
    });

    test('TopRatedTvError supports value equality', () {
      expect(
        const TopRatedTvError('error'),
        equals(const TopRatedTvError('error')),
      );
    });

    test('TopRatedTvLoaded props are correct', () {
      const tTv = Tv(
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        voteAverage: 1.0,
      );
      expect(
        const TopRatedTvLoaded([tTv]).props,
        equals([
          [tTv],
        ]),
      );
    });

    test('TopRatedTvError props are correct', () {
      expect(const TopRatedTvError('error').props, equals(['error']));
    });
  });
}
