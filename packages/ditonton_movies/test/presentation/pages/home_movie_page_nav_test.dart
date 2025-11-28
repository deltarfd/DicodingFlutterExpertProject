import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _Repo implements MovieRepository {
  final List<Movie> list;
  _Repo(this.list);
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async => Right(list);
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async => Right(list);
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async => Right(list);
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

class TestNavigatorObserver extends NavigatorObserver {
  final pushed = <String?>[];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route.settings.name);
    super.didPush(route, previousRoute);
  }
}

void main() {
  testWidgets('Home page routes: icons push expected named routes', (tester) async {
    const m = Movie(
      adult: false, backdropPath: 'b', genreIds: [], id: 7,
      originalTitle: 'OT', overview: 'OV', popularity: 0,
      posterPath: '/p', releaseDate: '2020-01-01', title: 'T', video: false,
      voteAverage: 0, voteCount: 0,
    );
    final repo = _Repo(const [m]);
    final observer = TestNavigatorObserver();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieListNotifier(
          getNowPlayingMovies: GetNowPlayingMovies(repo),
          getPopularMovies: GetPopularMovies(repo),
          getTopRatedMovies: GetTopRatedMovies(repo),
        )),
      ],
      child: MaterialApp(
        navigatorObservers: [observer],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => const SizedBox.shrink(),
          settings: settings,
        ),
        home: const HomeMoviePage(),
      ),
    ));

    await tester.pump(const Duration(milliseconds: 200));

    // Trigger Watchlist icon
    final watchIconBtn = tester.widgetList<IconButton>(find.byType(IconButton))
        .firstWhere((b) => b.icon is Icon && (b.icon as Icon).icon == Icons.bookmark);
    watchIconBtn.onPressed!.call();
    await tester.pump(const Duration(milliseconds: 20));
    expect(observer.pushed.last, WatchlistMoviesPage.ROUTE_NAME);

    // Trigger Search icon
    final searchIconBtn = tester.widgetList<IconButton>(find.byType(IconButton))
        .firstWhere((b) => b.icon is Icon && (b.icon as Icon).icon == Icons.search);
    searchIconBtn.onPressed!.call();
    await tester.pump(const Duration(milliseconds: 20));
    expect(observer.pushed.last, SearchPage.ROUTE_NAME);
  });
}
