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
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class _Shared {
  static late SharedPreferences instance;
}

class MockSearchRecentCubit extends Mock implements SearchRecentCubit {}

class _Repo implements MovieRepository {
  final Either<Failure, List<Movie>> result;
  _Repo(this.result);

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      result;

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async =>
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

Widget _app(MovieRepository repo) => MaterialApp(
      navigatorObservers: [routeObserver],
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MovieSearchBloc(searchMovies: SearchMovies(repo)),
          ),
          BlocProvider<SearchRecentCubit>(
            create: (_) => SearchRecentCubit(_Shared.instance),
          ),
        ],
        child: const SearchPage(),
      ),
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    _Shared.instance = await SharedPreferences.getInstance();
  });

  testWidgets('SearchPage shows empty state message', (tester) async {
    final repo = _Repo(const Right([]));
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    final field = find.byType(TextField);
    await tester.enterText(field, 'xyz123notfound');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('SearchPage onChanged with short query shows hint',
      (tester) async {
    final repo = _Repo(Right(testMovieList));
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    final field = find.byType(TextField);
    await tester.enterText(field, 's');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Type at least 2 characters to search'), findsOneWidget);
  });
}
