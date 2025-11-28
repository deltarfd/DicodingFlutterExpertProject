import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> onTheAir = const [];
  List<Tv> topRated = const [];
  Failure? onTheAirFailure;
  Failure? topRatedFailure;
  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTv() async =>
      onTheAirFailure != null ? Left(onTheAirFailure!) : Right(onTheAir);
  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async =>
      topRatedFailure != null ? Left(topRatedFailure!) : Right(topRated);
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final tvs = [
    const Tv(
        id: 1, name: 'T', overview: 'O', posterPath: '/x', voteAverage: 7.0),
  ];

  group('OnTheAirTvBloc', () {
    blocTest<OnTheAirTvBloc, OnTheAirTvState>(
      'success',
      build: () {
        final repo = _FakeRepo()..onTheAir = tvs;
        return OnTheAirTvBloc(getOnTheAirTv: GetOnTheAirTv(repo));
      },
      act: (b) => b.add(FetchOnTheAirTv()),
      expect: () => [isA<OnTheAirTvLoading>(), OnTheAirTvLoaded(tvs)],
    );

    blocTest<OnTheAirTvBloc, OnTheAirTvState>(
      'failure',
      build: () {
        final repo = _FakeRepo()..onTheAirFailure = const ServerFailure('err');
        return OnTheAirTvBloc(getOnTheAirTv: GetOnTheAirTv(repo));
      },
      act: (b) => b.add(FetchOnTheAirTv()),
      expect: () => [isA<OnTheAirTvLoading>(), const OnTheAirTvError('err')],
    );
  });

  group('TopRatedTvBloc', () {
    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'success',
      build: () {
        final repo = _FakeRepo()..topRated = tvs;
        return TopRatedTvBloc(getTopRatedTv: GetTopRatedTv(repo));
      },
      act: (b) => b.add(FetchTopRatedTv()),
      expect: () => [isA<TopRatedTvLoading>(), TopRatedTvLoaded(tvs)],
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'failure',
      build: () {
        final repo = _FakeRepo()..topRatedFailure = const ServerFailure('err');
        return TopRatedTvBloc(getTopRatedTv: GetTopRatedTv(repo));
      },
      act: (b) => b.add(FetchTopRatedTv()),
      expect: () => [isA<TopRatedTvLoading>(), const TopRatedTvError('err')],
    );
  });
}
