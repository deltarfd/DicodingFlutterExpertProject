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
import 'package:shared_preferences/shared_preferences.dart';

import '../../dummy_data/dummy_objects.dart';

class _Repo implements MovieRepository {
  final Either<Failure, List<Movie>> result;
  _Repo(this.result);
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async => result;
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
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async => throw UnimplementedError();
}

Widget _app(MovieRepository repo) => MaterialApp(
      navigatorObservers: [routeObserver],
      home: BlocProvider(
        create: (_) => MovieSearchBloc(searchMovies: SearchMovies(repo)),
        child: const SearchPage(),
      ),
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SearchPage shows result list', (tester) async {
    final repo = _Repo(Right(testMovieList));
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    final field = find.byType(TextField);
    await tester.enterText(field, 'spi');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('SearchPage shows error text', (tester) async {
    final repo = _Repo(const Left(ServerFailure('boom')));
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    final field = find.byType(TextField);
    await tester.enterText(field, 'xx');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('boom'), findsOneWidget);
  });
}
