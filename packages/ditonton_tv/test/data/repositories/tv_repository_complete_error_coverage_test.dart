import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_table.dart';
import 'package:ditonton_tv/features/tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

class _RemoteServerError implements TvRemoteDataSource {
  @override
  Future<List<TvModel>> getAiringTodayTv() async => throw ServerException();
  @override
  Future<List<TvModel>> getPopularTv() async => throw ServerException();
  @override
  Future<List<TvModel>> getTopRatedTv() async => throw ServerException();
  @override
  Future<TvDetailResponse> getTvDetail(int id) async => throw ServerException();
  @override
  Future<List<TvModel>> getTvRecommendations(int id) async =>
      throw ServerException();
  @override
  Future<List<TvModel>> searchTv(String query) async => throw ServerException();
  @override
  Future<SeasonDetailResponse> getSeasonDetail(
    int tvId,
    int seasonNumber,
  ) async => throw ServerException();
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _RemoteSocketError implements TvRemoteDataSource {
  @override
  Future<List<TvModel>> getAiringTodayTv() async =>
      throw const SocketException('');
  @override
  Future<List<TvModel>> getPopularTv() async => throw const SocketException('');
  @override
  Future<List<TvModel>> getTopRatedTv() async =>
      throw const SocketException('');
  @override
  Future<TvDetailResponse> getTvDetail(int id) async =>
      throw const SocketException('');
  @override
  Future<List<TvModel>> getTvRecommendations(int id) async =>
      throw const SocketException('');
  @override
  Future<List<TvModel>> searchTv(String query) async =>
      throw const SocketException('');
  @override
  Future<SeasonDetailResponse> getSeasonDetail(
    int tvId,
    int seasonNumber,
  ) async => throw const SocketException('');
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _LocalOk implements TvLocalDataSource {
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  group('TvRepositoryImpl - Complete ServerException Coverage', () {
    test('getAiringTodayTv ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getAiringTodayTv();
      expect(result.isLeft(), true);
    });

    test('getPopularTv ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getPopularTv();
      expect(result.isLeft(), true);
    });

    test('getTopRatedTv ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getTopRatedTv();
      expect(result.isLeft(), true);
    });

    test('getTvDetail ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getTvDetail(1);
      expect(result.isLeft(), true);
    });

    test('getTvRecommendations ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getTvRecommendations(1);
      expect(result.isLeft(), true);
    });

    test('searchTv ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.searchTv('query');
      expect(result.isLeft(), true);
    });

    test('getSeasonDetail ServerException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteServerError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getSeasonDetail(1, 1);
      expect(result.isLeft(), true);
    });
  });

  group('TvRepositoryImpl - Complete SocketException Coverage', () {
    test('getAiringTodayTv SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getAiringTodayTv();
      expect(result.isLeft(), true);
    });

    test('getPopularTv SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getPopularTv();
      expect(result.isLeft(), true);
    });

    test('getTopRatedTv SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getTopRatedTv();
      expect(result.isLeft(), true);
    });

    test('getTvDetail SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getTvDetail(1);
      expect(result.isLeft(), true);
    });

    test('getTvRecommendations SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getTvRecommendations(1);
      expect(result.isLeft(), true);
    });

    test('searchTv SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.searchTv('query');
      expect(result.isLeft(), true);
    });

    test('getSeasonDetail SocketException', () async {
      final repo = TvRepositoryImpl(
        remoteDataSource: _RemoteSocketError(),
        localDataSource: _LocalOk(),
      );
      final result = await repo.getSeasonDetail(1, 1);
      expect(result.isLeft(), true);
    });
  });
}
