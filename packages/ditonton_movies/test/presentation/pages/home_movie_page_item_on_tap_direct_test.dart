import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../../dummy_data/dummy_objects.dart';

class _Repo implements MovieRepository {
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async => Right([testMovie]);
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

void main() {
  testWidgets('Directly invoke _MovieList item onTap to push detail route', (tester) async {
    int? navigatedId;
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => MovieListNotifier(
        getNowPlayingMovies: GetNowPlayingMovies(_Repo()),
        getPopularMovies: GetPopularMovies(_Repo()),
        getTopRatedMovies: GetTopRatedMovies(_Repo()),
      ),
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.ROUTE_NAME) {
            navigatedId = settings.arguments as int?;
            return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
          }
          return MaterialPageRoute(builder: (_) => const HomeMoviePage());
        },
      ),
    ));

    await tester.pump(const Duration(milliseconds: 200));

    // Find first InkWell in the horizontal list and invoke onTap directly
    final inkwell = tester.widget<InkWell>(find.byType(InkWell).first);
    inkwell.onTap!.call();
    await tester.pump();

    expect(navigatedId, testMovie.id);
  });
}
