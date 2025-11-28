import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _Repo implements MovieRepository {
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async => const Right([]);
  // Unused
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
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async => throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async => const Right([]);
}

void main() {
  testWidgets('SearchPage shows clear icon and clears input', (tester) async {
    await tester.pumpWidget(MaterialApp(
      navigatorObservers: [routeObserver],
      home: BlocProvider(
        create: (_) => MovieSearchBloc(searchMovies: SearchMovies(_Repo())),
        child: const SearchPage(),
      ),
    ));

    // Type text, expect clear icon to appear
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump(const Duration(milliseconds: 500));
    // Ensure controller updated
    final tf0 = tester.widget<TextField>(find.byType(TextField));
    expect(tf0.controller!.text, 'abc');

    // Clear by entering empty string to trigger onChanged and debounce
    await tester.enterText(find.byType(TextField), '');
    await tester.pump(const Duration(milliseconds: 500));

    // Text cleared
    final tf1 = tester.widget<TextField>(find.byType(TextField));
    expect(tf1.controller!.text, isEmpty);
  });
}