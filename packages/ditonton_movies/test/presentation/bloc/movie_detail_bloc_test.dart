import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/save_watchlist.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: const [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

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
  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(state: RequestState.Loading),
        MovieDetailState.initial().copyWith(
          state: RequestState.Loaded,
          movieDetail: tMovieDetail,
          movieRecommendations: tMovies,
          recommendationState: RequestState.Loaded,
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(state: RequestState.Loading),
        MovieDetailState.initial().copyWith(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [watchlistStatus] when LoadWatchlistStatus is added',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [watchlistMessage] when AddWatchlist is added successfully',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(tMovieDetail)),
      expect: () => [
        MovieDetailState.initial()
            .copyWith(watchlistMessage: 'Added to Watchlist'),
        MovieDetailState.initial().copyWith(
            watchlistMessage: 'Added to Watchlist', isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [watchlistMessage] when RemoveWatchlist is added successfully',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tMovieDetail)),
      expect: () => [
        MovieDetailState.initial()
            .copyWith(watchlistMessage: 'Removed from Watchlist'),
        MovieDetailState.initial().copyWith(
            watchlistMessage: 'Removed from Watchlist',
            isAddedToWatchlist: false),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tId));
      },
    );
  });
}
