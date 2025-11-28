import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_table.dart';
import 'package:ditonton_tv/features/tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemote implements TvRemoteDataSource {
  List<TvModel> tvList = const [];
  TvDetailResponse detail = const TvDetailResponse(
    id: 1,
    name: 'Detail',
    overview: 'Overview',
    posterPath: '/detail.jpg',
    voteAverage: 8.5,
    genres: [],
    seasons: [],
  );
  SeasonDetailResponse seasonDetail = const SeasonDetailResponse(
    id: 1,
    seasonNumber: 1,
    episodes: [],
  );
  bool throwServer = false;
  bool throwSocket = false;

  Future<List<TvModel>> _guardedListCall() async {
    if (throwServer) throw ServerException();
    if (throwSocket) throw const SocketException('Failed to connect');
    return tvList;
  }

  Future<T> _guardedDetailCall<T>(T value) async {
    if (throwServer) throw ServerException();
    if (throwSocket) throw const SocketException('Failed to connect');
    return value;
  }

  @override
  Future<List<TvModel>> getAiringTodayTv() => _guardedListCall();

  @override
  Future<List<TvModel>> getOnTheAirTv() => _guardedListCall();

  @override
  Future<List<TvModel>> getPopularTv() => _guardedListCall();

  @override
  Future<List<TvModel>> getTopRatedTv() => _guardedListCall();

  @override
  Future<TvDetailResponse> getTvDetail(int id) => _guardedDetailCall(detail);

  @override
  Future<List<TvModel>> getTvRecommendations(int id) => _guardedListCall();

  @override
  Future<List<TvModel>> searchTv(String query) => _guardedListCall();

  @override
  Future<SeasonDetailResponse> getSeasonDetail(int tvId, int seasonNumber) =>
      _guardedDetailCall(seasonDetail);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLocal implements TvLocalDataSource {
  bool throwDatabase = false;
  bool throwUnknown = false;

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    if (throwDatabase) throw DatabaseException('Error');
    if (throwUnknown) throw Exception('Unknown');
    return 'Added to Watchlist';
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    if (throwDatabase) throw DatabaseException('Error');
    return 'Removed from Watchlist';
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeRemote remote;
  late _FakeLocal local;
  late TvRepositoryImpl repo;

  setUp(() {
    remote = _FakeRemote();
    local = _FakeLocal();
    repo = TvRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  });

  group('Airing Today', () {
    test('returns list of Tv on success', () async {
      remote.tvList = const [
        TvModel(
          id: 1,
          name: 'A',
          overview: 'O',
          posterPath: '/x',
          voteAverage: 7.0,
        ),
      ];
      final result = await repo.getAiringTodayTv();
      expect(result, isA<Right<Failure, List<Tv>>>());
    });

    test('returns ServerFailure on ServerException', () async {
      remote.throwServer = true;
      final result = await repo.getAiringTodayTv();
      expect(result, isA<Left<Failure, List<Tv>>>());
    });
  });

  group('Watchlist', () {
    const detail = TvDetail(
      id: 1,
      name: 'N',
      overview: 'O',
      posterPath: '/p',
      voteAverage: 8.0,
      genres: [],
      seasons: [],
    );

    test('save watchlist success', () async {
      final result = await repo.saveWatchlist(detail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('remove watchlist success', () async {
      final result = await repo.removeWatchlist(detail);
      expect(result, const Right('Removed from Watchlist'));
    });
  });

  group('Additional Coverage Tests', () {
    const detail = TvDetail(
      id: 1,
      name: 'N',
      overview: 'O',
      posterPath: '/p',
      voteAverage: 8.0,
      genres: [],
      seasons: [],
    );

    test('getOnTheAirTv handles network errors', () async {
      remote.throwServer = true;
      final result = await repo.getOnTheAirTv();
      expect(result, isA<Left<Failure, List<Tv>>>());
    });

    test('getOnTheAirTv handles socket exception', () async {
      remote.throwSocket = true;
      final result = await repo.getOnTheAirTv();
      expect(result, isA<Left<Failure, List<Tv>>>());
    });

    test('getPopularTv returns data on success', () async {
      remote.tvList = const [
        TvModel(
          id: 2,
          name: 'Popular',
          overview: 'P',
          posterPath: '/p',
          voteAverage: 8.0,
        ),
      ];
      final result = await repo.getPopularTv();
      expect(result, isA<Right<Failure, List<Tv>>>());
    });

    test('getTopRatedTv returns data on success', () async {
      remote.tvList = const [
        TvModel(
          id: 3,
          name: 'Top',
          overview: 'T',
          posterPath: '/t',
          voteAverage: 9.0,
        ),
      ];
      final result = await repo.getTopRatedTv();
      expect(result, isA<Right<Failure, List<Tv>>>());
    });

    test(
      'saveWatchlist returns DatabaseFailure on DatabaseException',
      () async {
        local.throwDatabase = true;
        final result = await repo.saveWatchlist(detail);
        expect(result, isA<Left<Failure, String>>());
      },
    );

    test('saveWatchlist rethrows unknown exception', () async {
      local.throwUnknown = true;
      expect(() => repo.saveWatchlist(detail), throwsException);
    });

    test(
      'removeWatchlist returns DatabaseFailure on DatabaseException',
      () async {
        local.throwDatabase = true;
        final result = await repo.removeWatchlist(detail);
        expect(result, isA<Left<Failure, String>>());
      },
    );

    test(
      'getSeasonDetail returns ConnectionFailure on SocketException',
      () async {
        remote.throwSocket = true;
        final result = await repo.getSeasonDetail(1, 1);
        expect(result, isA<Left<Failure, SeasonDetail>>());
      },
    );

    test('getSeasonDetail returns data on success', () async {
      final result = await repo.getSeasonDetail(1, 1);
      expect(result, isA<Right<Failure, SeasonDetail>>());
    });
  });
}
