import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> data = const [];
  Failure? failure;
  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async =>
      failure != null ? Left(failure!) : Right(data);
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  blocTest<TvSearchBloc, TvSearchState>(
    'emits Loaded on success',
    build: () {
      final repo = _FakeRepo()
        ..data = const [
          Tv(
            id: 1,
            name: 'A',
            overview: 'O',
            posterPath: '/x',
            voteAverage: 7.0,
          ),
        ];
      return TvSearchBloc(searchTv: SearchTv(repo));
    },
    act: (b) => b.add(const SubmitTvQuery('query')),
    expect: () => [isA<TvSearchLoading>(), isA<TvSearchLoaded>()],
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'emits Error when search fails',
    build: () {
      final repo = _FakeRepo()..failure = const ServerFailure('Network error');
      return TvSearchBloc(searchTv: SearchTv(repo));
    },
    act: (b) => b.add(const SubmitTvQuery('query')),
    expect: () => [
      isA<TvSearchLoading>(),
      const TvSearchError('Network error'),
    ],
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'emits empty list when search returns no results',
    build: () {
      final repo = _FakeRepo()..data = const [];
      return TvSearchBloc(searchTv: SearchTv(repo));
    },
    act: (b) => b.add(const SubmitTvQuery('nonexistent')),
    expect: () => [isA<TvSearchLoading>(), const TvSearchLoaded([])],
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'emits Initial when ClearTvQuery is called',
    build: () {
      final repo = _FakeRepo();
      return TvSearchBloc(searchTv: SearchTv(repo));
    },
    act: (b) => b.add(ClearTvQuery()),
    expect: () => [TvSearchInitial()],
  );
}
