import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  TvDetail? detail;
  List<Tv> recs = const [];
  bool watchlisted = false;
  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async => Right(detail!);
  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async =>
      Right(recs);
  @override
  Future<bool> isAddedToWatchlist(int id) async => watchlisted;
  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    watchlisted = true;
    return const Right('Added to Watchlist');
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    watchlisted = false;
    return const Right('Removed from Watchlist');
  }

  @override
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(
          int tvId, int seasonNumber) async =>
      const Right(SeasonDetail(id: 0, seasonNumber: 1, episodes: []));
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  test('TvDetailNotifier fetch/set watchlist', () async {
    final repo = _FakeRepo()
      ..detail = const TvDetail(
          id: 1,
          name: 'N',
          overview: 'O',
          posterPath: '/p',
          voteAverage: 8.0,
          genres: [],
          seasons: [])
      ..recs = const [
        Tv(id: 2, name: 'R', overview: 'O', posterPath: '/p', voteAverage: 7.0)
      ];

    final notifier = TvDetailNotifier(
      getTvDetail: GetTvDetail(repo),
      getTvRecommendations: GetTvRecommendations(repo),
      getWatchlistStatusTv: GetWatchlistStatusTv(repo),
      saveWatchlistTv: SaveWatchlistTv(repo),
      removeWatchlistTv: RemoveWatchlistTv(repo),
      getSeasonDetail: GetSeasonDetail(repo),
    );

    await notifier.fetchTvDetail(1);
    expect(notifier.tv.id, 1);
    await notifier.loadWatchlistStatus(1);
    expect(notifier.isAddedToWatchlist, false);
    await notifier.addWatchlist(notifier.tv);
    expect(notifier.watchlistMessage.isNotEmpty, true);
  });
}
