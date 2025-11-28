import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _RepoOk implements MovieRepository {
  final List<Movie> list;
  _RepoOk(this.list);
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async => Right(list);
  // Unused
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async => throw UnimplementedError();
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async => throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async => throw UnimplementedError();
}

class _RepoErr extends _RepoOk {
  _RepoErr(): super(const []);
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async => const Left(ServerFailure('boom'));
}

void main() {
  test('MovieSearchBloc emits Loading then Loaded', () async {
    final bloc = MovieSearchBloc(searchMovies: SearchMovies(_RepoOk(const [
      Movie(
        adult: false,
        backdropPath: 'b',
        genreIds: [],
        id: 1,
        originalTitle: 'OT',
        overview: 'OV',
        popularity: 0,
        posterPath: '/p',
        releaseDate: '2020-01-01',
        title: 'T',
        video: false,
        voteAverage: 0,
        voteCount: 0,
      )
    ])));
    addTearDown(bloc.close);
    expectLater(
      bloc.stream,
      emitsInOrder([isA<MovieSearchLoading>(), isA<MovieSearchLoaded>()]),
    );
    bloc.add(const SubmitMovieQuery('ab'));
  });

  test('MovieSearchBloc emits Loading then Error', () async {
    final bloc = MovieSearchBloc(searchMovies: SearchMovies(_RepoErr()));
    addTearDown(bloc.close);
    expectLater(
      bloc.stream,
      emitsInOrder([isA<MovieSearchLoading>(), isA<MovieSearchError>()]),
    );
    bloc.add(const SubmitMovieQuery('ab'));
  });
}