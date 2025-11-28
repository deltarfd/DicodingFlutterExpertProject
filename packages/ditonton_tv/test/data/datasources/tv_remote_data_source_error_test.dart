import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late TvRemoteDataSourceImpl ds;

  setUp(() {
    // default; override per test
    ds = TvRemoteDataSourceImpl(client: http.Client());
  });

  test('all endpoints throw ServerException when non-200', () async {
    const base = 'https://api.themoviedb.org/3';
    const key = TvRemoteDataSourceImpl.apiKey;

    final client = MockClient((req) async => http.Response('oops', 404));
    ds = TvRemoteDataSourceImpl(client: client);

    expect(ds.getOnTheAirTv(), throwsA(isA<ServerException>()));
    expect(ds.getAiringTodayTv(), throwsA(isA<ServerException>()));
    expect(ds.getTvDetail(1), throwsA(isA<ServerException>()));
    expect(ds.getTvRecommendations(1), throwsA(isA<ServerException>()));
    expect(ds.getPopularTv(), throwsA(isA<ServerException>()));
    expect(ds.getTopRatedTv(), throwsA(isA<ServerException>()));
    expect(ds.searchTv('q'), throwsA(isA<ServerException>()));
    expect(ds.getSeasonDetail(1, 1), throwsA(isA<ServerException>()));

    client.close();
  });
}
