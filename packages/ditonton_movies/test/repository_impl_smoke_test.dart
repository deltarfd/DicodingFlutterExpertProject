import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_movies/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton_movies/features/movies/data/models/movie_model.dart';
import 'package:ditonton_movies/features/movies/data/models/movie_table.dart';
import 'package:ditonton_movies/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/save_watchlist.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';

class _RemoteOk implements MovieRemoteDataSource {
  List<MovieModel> list = const [];
  MovieDetailResponse? detail;
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async => list;
  @override
  Future<List<MovieModel>> getPopularMovies() async => list;
  @override
  Future<List<MovieModel>> getTopRatedMovies() async => list;
  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async => detail!;
  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async => list;
  @override
  Future<List<MovieModel>> searchMovies(String query) async => list;
}

class _RemoteServerErr extends _RemoteOk {
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async => throw ServerException();
}

class _RemoteSocketErr extends _RemoteOk {
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async => throw const SocketException('x');
}

class _LocalOk implements MovieLocalDataSource {
  final Map<int, MovieTable> store = {};
  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    store[movie.id] = movie;
    return 'Added to Watchlist';
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    store.remove(movie.id);
    return 'Removed from Watchlist';
  }

  @override
  Future<MovieTable?> getMovieById(int id) async => store[id];
  @override
  Future<List<MovieTable>> getWatchlistMovies() async => store.values.toList();
}

void main() {
  group('Movies package smoke coverage', () {
    test('exercise repository and usecases', () async {
      final remote = _RemoteOk()
        ..list = const [
          MovieModel(
            adult: false,
            backdropPath: '/b',
            genreIds: [1],
            id: 1,
            originalTitle: 'OT',
            overview: 'O',
            popularity: 1.0,
            posterPath: '/p',
            releaseDate: '2020-01-01',
            title: 'T',
            video: false,
            voteAverage: 8.0,
            voteCount: 1,
          )
        ]
        ..detail = const MovieDetailResponse(
          adult: false,
          backdropPath: 'b',
          budget: 0,
          genres: [],
          homepage: '-',
          id: 1,
          imdbId: 'imdb1',
          originalLanguage: 'en',
          originalTitle: 'OT',
          overview: 'O',
          popularity: 1.0,
          posterPath: '/p',
          releaseDate: '2020-01-01',
          revenue: 0,
          runtime: 120,
          status: 'Released',
          tagline: '-',
          title: 'T',
          video: false,
          voteAverage: 8.0,
          voteCount: 1,
        );
      final repo = MovieRepositoryImpl(remoteDataSource: remote, localDataSource: _LocalOk());

      // List endpoints
      expect((await repo.getNowPlayingMovies()) is Right, true);
      expect((await repo.getPopularMovies()) is Right, true);
      expect((await repo.getTopRatedMovies()) is Right, true);
      expect((await repo.searchMovies('q')) is Right, true);

      // Detail/recs
      expect((await repo.getMovieDetail(1)) is Right, true);
      expect((await repo.getMovieRecommendations(1)) is Right, true);

      // Usecases
      expect((await GetNowPlayingMovies(repo).execute()) is Right, true);
      expect((await GetPopularMovies(repo).execute()) is Right, true);
      expect((await GetTopRatedMovies(repo).execute()) is Right, true);
      expect((await SearchMovies(repo).execute('q')) is Right, true);
      expect((await GetMovieDetail(repo).execute(1)) is Right, true);
      expect((await GetMovieRecommendations(repo).execute(1)) is Right, true);

      // Watchlist
      const detail = MovieDetail(
        adult: false,
        backdropPath: 'b',
        genres: [],
        id: 1,
        originalTitle: 'OT',
        overview: 'O',
        posterPath: '/p',
        releaseDate: '2020-01-01',
        runtime: 120,
        title: 'T',
        voteAverage: 8.0,
        voteCount: 1,
      );
      expect((await SaveWatchlist(repo).execute(detail)) is Right, true);
      expect(await GetWatchListStatus(repo).execute(1), true);
      expect((await GetWatchlistMovies(repo).execute()) is Right, true);
      expect((await RemoveWatchlist(repo).execute(detail)) is Right, true);

      // Failure branches
      final repoServerErr = MovieRepositoryImpl(remoteDataSource: _RemoteServerErr(), localDataSource: _LocalOk());
      expect((await repoServerErr.getNowPlayingMovies()) is Left, true);
      final repoSocketErr = MovieRepositoryImpl(remoteDataSource: _RemoteSocketErr(), localDataSource: _LocalOk());
      expect((await repoSocketErr.getNowPlayingMovies()) is Left, true);
    });
  });
}
