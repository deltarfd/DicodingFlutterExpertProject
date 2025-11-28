import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> result = const [];
  @override
  Future<Either<Failure, List<Tv>>> getAiringTodayTv() async => Right(result);
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('GetAiringTodayTv should get list of airing today from repository',
      () async {
    final repo = _FakeRepo()
      ..result = const [
        Tv(
            id: 1,
            name: 'Airing',
            overview: 'Overview',
            posterPath: '/x',
            voteAverage: 7.5)
      ];
    final usecase = GetAiringTodayTv(repo);

    final result = await usecase.execute();

    expect(result, Right(repo.result));
  });
}
