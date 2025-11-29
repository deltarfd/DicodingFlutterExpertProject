import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistMovieEmpty());
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

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieLoaded(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure("Can't get data")));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
