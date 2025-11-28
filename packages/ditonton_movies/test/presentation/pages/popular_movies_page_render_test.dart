import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _Repo implements MovieRepository {
  final List<Movie> list;
  _Repo(this.list);
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async => Right(list);
  // Unused
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async => throw UnimplementedError();
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
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async => const Right([]);
}

void main() {
  testWidgets('Popular page renders MovieCard when loaded with data', (tester) async {
    final repo = _Repo(const [Movie(
      adult: false, backdropPath: 'b', genreIds: [], id: 1,
      originalTitle: 'OT', overview: 'OV', popularity: 0,
      posterPath: '/p', releaseDate: '2020-01-01', title: 'T', video: false,
      voteAverage: 0, voteCount: 0,
    )]);
    await tester.pumpWidget(ChangeNotifierProvider<PopularMoviesNotifier>(
      create: (_) => PopularMoviesNotifier(GetPopularMovies(repo)),
      child: const MaterialApp(home: PopularMoviesPage()),
    ));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('T'), findsOneWidget);
  });
}
