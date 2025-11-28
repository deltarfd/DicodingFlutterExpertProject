import 'dart:convert';

import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('TvRemoteDataSource', () {
    test('getAiringTodayTv returns list on 200', () async {
      final client = MockClient((request) async {
        expect(request.url.path, contains('/tv/airing_today'));
        return http.Response(
            jsonEncode({
              'results': [
                {
                  'id': 1,
                  'name': 'Show',
                  'overview': 'O',
                  'poster_path': '/p',
                  'vote_average': 7.0
                }
              ]
            }),
            200);
      });
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.getAiringTodayTv();
      expect(result, isA<List<TvModel>>());
      expect(result.length, 1);
      client.close();
    });

    test('getAiringTodayTv throws ServerException on non-200', () async {
      final client = MockClient((request) async => http.Response('err', 500));
      final ds = TvRemoteDataSourceImpl(client: client);
      expect(ds.getAiringTodayTv, throwsA(isA<ServerException>()));
      client.close();
    });

    test('getSeasonDetail returns SeasonDetailResponse on 200', () async {
      final client = MockClient((request) async {
        expect(request.url.path, contains('/tv/1/season/2'));
        return http.Response(
            jsonEncode({
              'id': 10,
              'season_number': 2,
              'episodes': [
                {
                  'id': 100,
                  'name': 'Ep1',
                  'episode_number': 1,
                  'overview': 'E1',
                  'still_path': '/s1'
                }
              ]
            }),
            200);
      });
      final ds = TvRemoteDataSourceImpl(client: client);
      final result = await ds.getSeasonDetail(1, 2);
      expect(result, isA<SeasonDetailResponse>());
      expect(result.episodes.length, 1);
      client.close();
    });
  });
}
