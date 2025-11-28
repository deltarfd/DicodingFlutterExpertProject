import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class _Repo implements MovieRepository {
  final Either<Failure, List<Movie>> watchlistResult;
  _Repo(this.watchlistResult);
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async => watchlistResult;
  // Unused paths for this widget
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
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async => throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
}

Widget _app(MovieRepository repo) => MaterialApp(
      navigatorObservers: [routeObserver],
      home: ChangeNotifierProvider(
        create: (_) => WatchlistMovieNotifier(
          getWatchlistMovies: GetWatchlistMovies(repo),
        ),
        child: const WatchlistMoviesPage(),
      ),
    );

void main() {
  testWidgets('Watchlist shows list when loaded', (tester) async {
    final repo = _Repo(Right([testWatchlistMovie]));
    await tester.pumpWidget(_app(repo));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Watchlist shows error message', (tester) async {
    final repo = _Repo(const Left(ServerFailure('oops')));
    await tester.pumpWidget(_app(repo));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
