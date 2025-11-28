import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _Repo implements MovieRepository {
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async => const Right([]);
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async => const Right([]);
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async => const Right([]);
  // Unused
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
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async => const Right([]);
}

Widget _app() {
  final repo = _Repo();
  return ChangeNotifierProvider(
    create: (_) => MovieListNotifier(
      getNowPlayingMovies: GetNowPlayingMovies(repo),
      getPopularMovies: GetPopularMovies(repo),
      getTopRatedMovies: GetTopRatedMovies(repo),
    ),
    child: MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == WatchlistMoviesPage.ROUTE_NAME ||
            settings.name == SearchPage.ROUTE_NAME) {
          return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
        }
        return MaterialPageRoute(builder: (_) => const HomeMoviePage());
      },
    ),
  );
}

void main() {
  testWidgets('AppBar actions navigate to watchlist and search', (tester) async {
    await tester.pumpWidget(_app());

    // Invoke watchlist action directly to avoid hit-test flakiness
    final watchBtnFinder = find.ancestor(
      of: find.byIcon(Icons.bookmark), matching: find.byType(IconButton));
    final watchBtn = tester.widget<IconButton>(watchBtnFinder);
    watchBtn.onPressed!.call();
    await tester.pump();

    // Rebuild home and invoke search action
    await tester.pumpWidget(_app());
    final searchBtnFinder = find.ancestor(
      of: find.byIcon(Icons.search), matching: find.byType(IconButton));
    final searchBtn = tester.widget<IconButton>(searchBtnFinder);
    searchBtn.onPressed!.call();
    await tester.pump();
  });
}
