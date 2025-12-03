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
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class _Shared {
  static late SharedPreferences instance;
}

class MockSearchRecentCubit extends Mock implements SearchRecentCubit {}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _TestHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() {
    return Future.value(_TestHttpClientResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _TestHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

const List<int> kTransparentImage = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

class _Repo implements MovieRepository {
  final Either<Failure, List<Movie>> result;
  _Repo(this.result);
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      result;
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
      throw UnimplementedError();
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
    HttpOverrides.global = MockHttpOverrides();
    SharedPreferences.setMockInitialValues({});
    _Shared.instance = await SharedPreferences.getInstance();
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
