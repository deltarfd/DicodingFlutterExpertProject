import 'package:ditonton_core/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
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

class _Repo implements MovieRepository {
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async =>
      Right([testMovie]);
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async =>
      const Right([]);
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async =>
      const Right([]);
  // Unused
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
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async =>
      throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async =>
      const Right([]);
}

void main() {
  testWidgets('_MovieList CachedNetworkImage builders can build',
      (tester) async {
    final repo = _Repo();
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => MovieListNotifier(
        getNowPlayingMovies: GetNowPlayingMovies(repo),
        getPopularMovies: GetPopularMovies(repo),
        getTopRatedMovies: GetTopRatedMovies(repo),
      ),
      child: const MaterialApp(home: HomeMoviePage()),
    ));

    await tester.pump(const Duration(milliseconds: 200));

    final ctx = tester.element(find.byType(Scaffold));
    final cached = tester
        .widget<CachedNetworkImage>(find.byType(CachedNetworkImage).first);
    final placeholder = cached.placeholder!;
    final errorBuilder = cached.errorWidget!;

    expect(placeholder(ctx, 'url'), isA<Widget>());
    expect(errorBuilder(ctx, 'url', Exception()), isA<Widget>());
  });
}
