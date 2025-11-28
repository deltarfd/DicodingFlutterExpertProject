import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class _FakeMovieRepository implements MovieRepository {
  final bool error;
  _FakeMovieRepository({this.error = false});
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async =>
      error ? const Left(ServerFailure('err')) : Right(testMovieList);
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async =>
      error ? const Left(ServerFailure('err')) : Right(testMovieList);
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async =>
      error ? const Left(ServerFailure('err')) : Right(testMovieList);
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async =>
      throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async =>
      throw UnimplementedError();
}

Widget _wrapWithProvider(MovieRepository repo) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MovieListNotifier(
          getNowPlayingMovies: GetNowPlayingMovies(repo),
          getPopularMovies: GetPopularMovies(repo),
          getTopRatedMovies: GetTopRatedMovies(repo),
        ),
      ),
    ],
    child: MaterialApp(
      navigatorObservers: [routeObserver],
      home: const HomeMoviePage(),
    ),
  );
}

void main() {
  testWidgets('HomeMoviePage shows lists when loaded', (tester) async {
    final repo = _FakeMovieRepository(error: false);
    await tester.pumpWidget(_wrapWithProvider(repo));
    // initial + async fetch
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    // There should be at least one poster tile (InkWell in list)
    expect(find.byType(InkWell), findsWidgets);
  });

  testWidgets('HomeMoviePage shows error text on failures', (tester) async {
    final repo = _FakeMovieRepository(error: true);
    await tester.pumpWidget(_wrapWithProvider(repo));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    // AnimatedSwitcher falls to Text('Failed') for each section on error
    expect(find.text('Failed'), findsWidgets);
  });
}
