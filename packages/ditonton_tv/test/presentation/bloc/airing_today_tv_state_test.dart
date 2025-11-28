import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiringTodayTvState', () {
    test('AiringTodayTvInitial supports value equality', () {
      expect(AiringTodayTvInitial(), equals(AiringTodayTvInitial()));
    });

    test('AiringTodayTvLoading supports value equality', () {
      expect(AiringTodayTvLoading(), equals(AiringTodayTvLoading()));
    });

    test('AiringTodayTvLoaded supports value equality', () {
      expect(
        const AiringTodayTvLoaded([]),
        equals(const AiringTodayTvLoaded([])),
      );
    });

    test('AiringTodayTvError supports value equality', () {
      expect(
        const AiringTodayTvError('error'),
        equals(const AiringTodayTvError('error')),
      );
    });

    test('AiringTodayTvLoaded props are correct', () {
      const tTv = Tv(
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        voteAverage: 1.0,
      );
      expect(
        const AiringTodayTvLoaded([tTv]).props,
        equals([
          [tTv],
        ]),
      );
    });

    test('AiringTodayTvError props are correct', () {
      expect(const AiringTodayTvError('error').props, equals(['error']));
    });
  });
}
