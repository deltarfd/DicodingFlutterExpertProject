import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> airingToday = const [];
  Failure? airingTodayFailure;

  @override
  Future<Either<Failure, List<Tv>>> getAiringTodayTv() async =>
      airingTodayFailure != null
      ? Left(airingTodayFailure!)
      : Right(airingToday);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final tvs = [
    const Tv(
      id: 1,
      name: 'Test',
      overview: 'O',
      posterPath: '/x',
      voteAverage: 7.0,
    ),
  ];

  group('AiringTodayTvBloc', () {
    blocTest<AiringTodayTvBloc, AiringTodayTvState>(
      'should emit [Loading, Loaded] when fetch is successful',
      build: () {
        final repo = _FakeRepo()..airingToday = tvs;
        return AiringTodayTvBloc(getAiringTodayTv: GetAiringTodayTv(repo));
      },
      act: (bloc) => bloc.add(FetchAiringTodayTv()),
      expect: () => [isA<AiringTodayTvLoading>(), AiringTodayTvLoaded(tvs)],
    );

    blocTest<AiringTodayTvBloc, AiringTodayTvState>(
      'should emit [Loading, Error] when fetch fails',
      build: () {
        final repo = _FakeRepo()
          ..airingTodayFailure = const ServerFailure('Network error');
        return AiringTodayTvBloc(getAiringTodayTv: GetAiringTodayTv(repo));
      },
      act: (bloc) => bloc.add(FetchAiringTodayTv()),
      expect: () => [
        isA<AiringTodayTvLoading>(),
        const AiringTodayTvError('Network error'),
      ],
    );

    test('initial state should be AiringTodayTvInitial', () {
      final repo = _FakeRepo();
      final bloc = AiringTodayTvBloc(getAiringTodayTv: GetAiringTodayTv(repo));
      expect(bloc.state, AiringTodayTvInitial());
    });
  });
}
