import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('initial state should be empty', () {
    expect(bloc.state, TopRatedMoviesEmpty());
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesLoaded(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      const TopRatedMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
