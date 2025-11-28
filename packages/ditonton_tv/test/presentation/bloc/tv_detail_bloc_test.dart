import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  _FakeRepo({required TvDetail initialDetail}) {
    detailResult = Right(initialDetail);
  }

  late Either<Failure, TvDetail> detailResult;
  Either<Failure, List<Tv>> recommendationsResult = Right(const []);
  bool watchlisted = false;
  Either<Failure, String> saveResult = Right('Added to Watchlist');
  Either<Failure, String> removeResult = Right('Removed from Watchlist');

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async => detailResult;

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async =>
      recommendationsResult;

  @override
  Future<bool> isAddedToWatchlist(int id) async => watchlisted;

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    if (saveResult.isRight()) watchlisted = true;
    return saveResult;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    if (removeResult.isRight()) watchlisted = false;
    return removeResult;
  }

  // Unused members
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TvDetailBloc _buildBloc(_FakeRepo repo) {
  return TvDetailBloc(
    getTvDetail: GetTvDetail(repo),
    getTvRecommendations: GetTvRecommendations(repo),
    getWatchlistStatusTv: GetWatchlistStatusTv(repo),
    saveWatchlistTv: SaveWatchlistTv(repo),
    removeWatchlistTv: RemoveWatchlistTv(repo),
  );
}

void main() {
  const tId = 1;
  const tDetail = TvDetail(
    id: tId,
    name: 'Name',
    overview: 'Overview',
    posterPath: '/x',
    voteAverage: 8.0,
    genres: [],
    seasons: [],
  );
  final tRecs = [
    const Tv(
      id: 2,
      name: 'Rec',
      overview: 'O',
      posterPath: '/y',
      voteAverage: 7.0,
    ),
  ];

  group('FetchTvDetailEvent', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits loaded state with recommendations and watchlist flag',
      build: () {
        final repo = _FakeRepo(initialDetail: tDetail)
          ..recommendationsResult = Right(tRecs)
          ..watchlisted = true;
        return _buildBloc(repo);
      },
      act: (bloc) => bloc.add(const FetchTvDetailEvent(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: tRecs,
          isInWatchlist: true,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'handles recommendation failure by falling back to empty list',
      build: () {
        final repo = _FakeRepo(initialDetail: tDetail)
          ..recommendationsResult =
              Left(ServerFailure('Failed to fetch recommendations'));
        return _buildBloc(repo);
      },
      act: (bloc) => bloc.add(const FetchTvDetailEvent(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: const [],
          isInWatchlist: false,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'emits error when detail retrieval fails',
      build: () {
        final repo = _FakeRepo(initialDetail: tDetail)
          ..detailResult =
              Left(ServerFailure('Failed to fetch TV detail'));
        return _buildBloc(repo);
      },
      act: (bloc) => bloc.add(const FetchTvDetailEvent(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.error,
          message: 'Failed to fetch TV detail',
        ),
      ],
    );
  });

  group('ToggleWatchlistEvent', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'adds to watchlist and updates message',
      build: () {
        final repo = _FakeRepo(initialDetail: tDetail)
          ..recommendationsResult = Right(tRecs);
        return _buildBloc(repo);
      },
      act: (bloc) async {
        bloc.add(const FetchTvDetailEvent(tId));
        await Future<void>.delayed(Duration.zero);
        bloc.add(ToggleWatchlistEvent());
      },
      expect: () => [
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: tRecs,
          isInWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: tRecs,
          isInWatchlist: true,
          message: 'Added to Watchlist',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'removes from watchlist when already added',
      build: () {
        final repo = _FakeRepo(initialDetail: tDetail)
          ..watchlisted = true;
        return _buildBloc(repo);
      },
      act: (bloc) async {
        bloc.add(const FetchTvDetailEvent(tId));
        await Future<void>.delayed(Duration.zero);
        bloc.add(ToggleWatchlistEvent());
      },
      expect: () => [
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: const [],
          isInWatchlist: true,
        ),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: const [],
          isInWatchlist: false,
          message: 'Removed from Watchlist',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'emits failure message when toggle fails',
      build: () {
        final repo = _FakeRepo(initialDetail: tDetail)
          ..saveResult =
              Left(DatabaseFailure('Unable to update watchlist'));
        return _buildBloc(repo);
      },
      act: (bloc) async {
        bloc.add(const FetchTvDetailEvent(tId));
        await Future<void>.delayed(Duration.zero);
        bloc.add(ToggleWatchlistEvent());
      },
      expect: () => [
        TvDetailState.initial().copyWith(status: TvDetailStatus.loading),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: const [],
          isInWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          status: TvDetailStatus.loaded,
          detail: tDetail,
          recommendations: const [],
          isInWatchlist: false,
          message: 'Unable to update watchlist',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'ignores toggle when detail has not been loaded',
      build: () => _buildBloc(_FakeRepo(initialDetail: tDetail)),
      act: (bloc) => bloc.add(ToggleWatchlistEvent()),
      expect: () => <TvDetailState>[],
    );
  });
}
