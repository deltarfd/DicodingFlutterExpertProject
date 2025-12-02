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
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      Right(list);
  // Unused
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async =>
      throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async =>
      throw UnimplementedError();
}

class _RepoErr extends _RepoOk {
  _RepoErr() : super(const []);
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      const Left(ServerFailure('boom'));
}

void main() {
  test('MovieSearchBloc emits Loading then Loaded', () async {
    final bloc = MovieSearchBloc(
        searchMovies: SearchMovies(_RepoOk(const [
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

  test('MovieSearchInitial should have props', () {
    final state = MovieSearchInitial();
    expect(state.props, []);
  });

  test('MovieSearchLoading should have correct props', () {
    final state1 = MovieSearchLoading();
    final state2 = MovieSearchLoading();
    expect(state1.props, []);
    expect(state1, state2);
  });

  test('MovieSearchLoaded should have correct props', () {
    final state1 = const MovieSearchLoaded([]);
    final state2 = const MovieSearchLoaded([]);
    expect(state1.props, [[]]);
    expect(state1, state2);
  });

  test('MovieSearchError should have correct props', () {
    final state1 = const MovieSearchError('error');
    final state2 = const MovieSearchError('error');
    expect(state1.props, ['error']);
    expect(state1, state2);
  });

  test('ClearMovieQuery should have props', () {
    final event = ClearMovieQuery();
    expect(event.props, []);
  });

  test('SubmitMovieQuery should have correct props', () {
    final event1 = const SubmitMovieQuery('query1');
    final event2 = const SubmitMovieQuery('query1');
    expect(event1.props, ['query1']);
    expect(event1, event2);
  });
}
