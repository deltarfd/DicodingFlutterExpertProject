import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> onTheAir = const [];
  List<Tv> airing = const [];
  List<Tv> popular = const [];
  List<Tv> topRated = const [];
  Failure? error;
  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTv() async =>
      error != null ? Left(error!) : Right(onTheAir);
  @override
  Future<Either<Failure, List<Tv>>> getAiringTodayTv() async =>
      error != null ? Left(error!) : Right(airing);
  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async =>
      error != null ? Left(error!) : Right(popular);
  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async =>
      error != null ? Left(error!) : Right(topRated);
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  test('TvListNotifier fetch methods set states and data', () async {
    final repo = _FakeRepo()
      ..onTheAir = const [
        Tv(id: 1, name: 'O', overview: 'o', posterPath: '/p', voteAverage: 7.0)
      ]
      ..airing = const []
      ..popular = const []
      ..topRated = const [];
    final notifier = TvListNotifier(
      getOnTheAirTv: GetOnTheAirTv(repo),
      getPopularTv: GetPopularTv(repo),
      getTopRatedTv: GetTopRatedTv(repo),
      getAiringTodayTv: GetAiringTodayTv(repo),
    );

    await notifier.fetchOnTheAirTv();
    expect(notifier.onTheAir.isNotEmpty, true);

    await notifier.fetchAiringTodayTv();
    expect(notifier.airingToday.length, 0);

    await notifier.fetchPopularTv();
    expect(notifier.popular.length, 0);

    await notifier.fetchTopRatedTv();
    expect(notifier.topRated.length, 0);
  });
}
