import 'dart:convert';

import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('TvRemoteDataSource extra endpoints', () {
    test('getOnTheAirTv returns list on 200', () async {
      final client = MockClient((_) async => http.Response(
          jsonEncode({
            'results': [
              {
                'id': 10,
                'name': 'On Air',
                'overview': 'O',
                'poster_path': '/p',
                'vote_average': 6.5
              }
            ]
          }),
          200));
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.getOnTheAirTv();
      expect(result, isA<List<TvModel>>());
      expect(result.first.id, 10);
      client.close();
    });

    test('getPopularTv returns list on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode({'results': []}), 200));
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.getPopularTv();
      expect(result, isA<List<TvModel>>());
      client.close();
    });

    test('getTopRatedTv returns list on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode({'results': []}), 200));
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.getTopRatedTv();
      expect(result, isA<List<TvModel>>());
      client.close();
    });

    test('getTvDetail returns detail on 200', () async {
      final client = MockClient((_) async => http.Response(
          jsonEncode({
            'id': 1,
            'name': 'Name',
            'overview': 'O',
            'poster_path': '/p',
            'vote_average': 8.0,
            'genres': [],
            'seasons': []
          }),
          200));
      final ds = TvRemoteDataSourceImpl(client: client);
      final detail = await ds.getTvDetail(1);
      expect(detail, isA<TvDetailResponse>());
      expect(detail.id, 1);
      client.close();
    });

    test('getTvRecommendations returns list on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode({'results': []}), 200));
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.getTvRecommendations(1);
      expect(result, isA<List<TvModel>>());
      client.close();
    });

    test('searchTv returns list on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode({'results': []}), 200));
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.searchTv('query');
      expect(result, isA<List<TvModel>>());
      client.close();
    });

    test('searchTv throws on non-200', () async {
      final client = MockClient((request) async => http.Response('err', 500));
      final ds = TvRemoteDataSourceImpl(client: client);
      expect(() => ds.searchTv('x'), throwsA(isA<Exception>()));
    });
  });
}
