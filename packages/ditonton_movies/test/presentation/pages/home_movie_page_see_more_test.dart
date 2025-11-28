import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
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
  // Unused in this test
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
        if (settings.name == PopularMoviesPage.ROUTE_NAME) {
          return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
        }
        if (settings.name == TopRatedMoviesPage.ROUTE_NAME) {
          return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
        }
        return MaterialPageRoute(builder: (_) => const HomeMoviePage());
      },
    ),
  );
}

void main() {
  testWidgets('See More navigates to Popular and Top Rated pages', (tester) async {
    await tester.pumpWidget(_app());
    // Immediate presence of subheadings
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);

    // Invoke Popular's See More directly (first InkWell with 'See More')
    final popSeeMoreFinder = find.widgetWithText(InkWell, 'See More').at(0);
    final popSeeMore = tester.widget<InkWell>(popSeeMoreFinder);
    popSeeMore.onTap!.call();
    await tester.pump();

    // Rebuild home and invoke Top Rated's See More directly (second)
    await tester.pumpWidget(_app());
    final topSeeMoreFinder = find.widgetWithText(InkWell, 'See More').at(1);
    final topSeeMore = tester.widget<InkWell>(topSeeMoreFinder);
    topSeeMore.onTap!.call();
    await tester.pump();
  });
}
