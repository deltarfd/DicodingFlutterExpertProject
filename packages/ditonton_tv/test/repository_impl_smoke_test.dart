import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_table.dart';
import 'package:ditonton_tv/features/tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';

class _RemoteOk implements TvRemoteDataSource {
  List<TvModel> list = const [];
  TvDetailResponse? detail;
  @override
  Future<List<TvModel>> getOnTheAirTv() async => list;
  @override
  Future<List<TvModel>> getAiringTodayTv() async => list;
  @override
  Future<List<TvModel>> getPopularTv() async => list;
  @override
  Future<List<TvModel>> getTopRatedTv() async => list;
  @override
  Future<TvDetailResponse> getTvDetail(int id) async => detail!;
  @override
  Future<List<TvModel>> getTvRecommendations(int id) async => list;
  @override
  Future<List<TvModel>> searchTv(String query) async => list;
  @override
  Future<SeasonDetailResponse> getSeasonDetail(int tvId, int seasonNumber) async =>
      const SeasonDetailResponse(id: 1, seasonNumber: 1, episodes: []);
}

class _RemoteServerErr extends _RemoteOk {
  @override
  Future<List<TvModel>> getOnTheAirTv() async => throw ServerException();
}

class _RemoteSocketErr extends _RemoteOk {
  @override
  Future<List<TvModel>> getOnTheAirTv() async => throw const SocketException('x');
}

class _LocalOk implements TvLocalDataSource {
  final Map<int, TvTable> store = {};
  @override
  Future<String> insertWatchlist(TvTable tv) async {
    store[tv.id] = tv;
    return 'Added to Watchlist';
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    store.remove(tv.id);
    return 'Removed from Watchlist';
  }

  @override
  Future<TvTable?> getTvById(int id) async => store[id];
  @override
  Future<List<TvTable>> getWatchlistTv() async => store.values.toList();
}

void main() {
  group('Tv package smoke coverage', () {
    test('exercise repository and usecases', () async {
      final remote = _RemoteOk()
        ..list = const [
          TvModel(id: 1, name: 'A', overview: 'O', posterPath: '/p', voteAverage: 7.0)
        ]
        ..detail = const TvDetailResponse(
          id: 1,
          name: 'N',
          overview: 'O',
          posterPath: '/p',
          voteAverage: 8.0,
          genres: [],
          seasons: [],
        );
      final repo = TvRepositoryImpl(remoteDataSource: remote, localDataSource: _LocalOk());

      // List endpoints
      expect((await repo.getOnTheAirTv()) is Right, true);
      expect((await repo.getAiringTodayTv()) is Right, true);
      expect((await repo.getPopularTv()) is Right, true);
      expect((await repo.getTopRatedTv()) is Right, true);
      expect((await repo.searchTv('q')) is Right, true);

      // Detail/recommendations
      expect((await repo.getTvDetail(1)) is Right, true);
      expect((await repo.getTvRecommendations(1)) is Right, true);

      // Usecases
      expect((await GetOnTheAirTv(repo).execute()) is Right, true);
      expect((await GetAiringTodayTv(repo).execute()) is Right, true);
      expect((await GetPopularTv(repo).execute()) is Right, true);
      expect((await GetTopRatedTv(repo).execute()) is Right, true);
      expect((await GetTvDetail(repo).execute(1)) is Right, true);
      expect((await GetTvRecommendations(repo).execute(1)) is Right, true);
      expect((await SearchTv(repo).execute('q')) is Right, true);

      // Watchlist
      const detail = TvDetail(
        id: 1,
        name: 'N',
        overview: 'O',
        posterPath: '/p',
        voteAverage: 8.0,
        genres: [],
        seasons: [],
      );
      expect((await SaveWatchlistTv(repo).execute(detail)) is Right, true);
      expect(await GetWatchlistStatusTv(repo).execute(1), true);
      expect((await GetWatchlistTv(repo).execute()) is Right, true);
      expect((await RemoveWatchlistTv(repo).execute(detail)) is Right, true);

      // Failure branches
      final repoServerErr = TvRepositoryImpl(remoteDataSource: _RemoteServerErr(), localDataSource: _LocalOk());
      expect((await repoServerErr.getOnTheAirTv()) is Left, true);
      final repoSocketErr = TvRepositoryImpl(remoteDataSource: _RemoteSocketErr(), localDataSource: _LocalOk());
      expect((await repoSocketErr.getOnTheAirTv()) is Left, true);
    });
  });
}
