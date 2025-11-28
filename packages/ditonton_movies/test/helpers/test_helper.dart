import 'package:ditonton_core/core/db/database_helper.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_remote_data_source.dart';
// TV mocks removed after migrating tests to fakes for TV feature
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
