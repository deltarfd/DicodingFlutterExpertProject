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

class _Shared {
  static late SharedPreferences instance;
}

class MockSearchRecentCubit extends Mock implements SearchRecentCubit {}

class _Repo implements MovieRepository {
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      const Right([]);
  // Unused
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'recent_searches_movies': ['Alien']
    });
    _Shared.instance = await SharedPreferences.getInstance();
  });

  testWidgets('SearchPage shows initial hint and recent chips', (tester) async {
    SharedPreferences.setMockInitialValues({
      'recent_searches_movies': ['Alien']
    });
    _Shared.instance = await SharedPreferences.getInstance();
    await tester.pumpWidget(MaterialApp(
      navigatorObservers: [routeObserver],
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MovieSearchBloc(searchMovies: SearchMovies(_Repo())),
          ),
          BlocProvider<SearchRecentCubit>(
            create: (_) => SearchRecentCubit(_Shared.instance),
          ),
        ],
        child: const SearchPage(),
      ),
    ));

    // Wait for async _loadRecent
    await tester.pump(const Duration(milliseconds: 100));

    // Initial hint
    expect(find.text('Type at least 2 characters to search'), findsOneWidget);
    // Recent chips
    expect(find.text('Recent'), findsOneWidget);
    expect(find.byType(ActionChip), findsWidgets);

    // Tap a recent chip and expect text field updated (clear icon appears)
    await tester.tap(find.byType(ActionChip).first);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byTooltip('Clear'), findsOneWidget);

    // Clear recent using Clear button
    await tester.tap(find.text('Clear'));
    await tester.pump();
    expect(find.byType(ActionChip), findsNothing);
  });
}
