import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> data = const [];
  Failure? failure;
  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async =>
      failure != null ? Left(failure!) : Right(data);
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final tvs = [
    const Tv(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/x',
        voteAverage: 8.0),
  ];

  blocTest<PopularTvBloc, PopularTvState>(
    'emits [Loading, Loaded] when success',
    build: () {
      final repo = _FakeRepo()..data = tvs;
      return PopularTvBloc(getPopularTv: GetPopularTv(repo));
    },
    act: (b) => b.add(FetchPopularTv()),
    expect: () => [isA<PopularTvLoading>(), PopularTvLoaded(tvs)],
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'emits [Loading, Error] when failure',
    build: () {
      final repo = _FakeRepo()..failure = const ServerFailure('error');
      return PopularTvBloc(getPopularTv: GetPopularTv(repo));
    },
    act: (b) => b.add(FetchPopularTv()),
    expect: () => [isA<PopularTvLoading>(), const PopularTvError('error')],
  );
}
