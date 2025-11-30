import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton/main.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_detail_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/top_rated_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton/main.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_detail_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/top_rated_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/popular_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/top_rated_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_list_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_search_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/watchlist_tv_notifier.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:ditonton/injection.dart' as di;

// Fakes extending mocktail.Mock and implementing original classes
class FakeThemeModeNotifier extends mocktail.Mock implements ThemeModeNotifier {
  @override
  ThemeMode get themeMode => ThemeMode.light;
  
  @override
  void toggle() {}
}

class FakeMovieListNotifier extends mocktail.Mock implements MovieListNotifier {
  @override
  RequestState get nowPlayingState => RequestState.Empty;
  @override
  List<Movie> get nowPlayingMovies => [];
  
  @override
  RequestState get popularMoviesState => RequestState.Empty;
  @override
  List<Movie> get popularMovies => [];
  
  @override
  RequestState get topRatedMoviesState => RequestState.Empty;
  @override
  List<Movie> get topRatedMovies => [];

  @override
  String get message => '';

  @override
  Future<void> fetchNowPlayingMovies() async {}
  @override
  Future<void> fetchPopularMovies() async {}
  @override
  Future<void> fetchTopRatedMovies() async {}
}

class FakeTvListNotifier extends mocktail.Mock implements TvListNotifier {
  @override
  RequestState get nowPlayingState => RequestState.Empty;
  @override
  List<Tv> get nowPlayingTv => [];
  
  @override
  RequestState get popularState => RequestState.Empty;
  @override
  List<Tv> get popularTv => [];
  
  @override
  RequestState get topRatedState => RequestState.Empty;
  @override
  List<Tv> get topRatedTv => [];
  
  @override
  RequestState get onTheAirState => RequestState.Empty;
  @override
  List<Tv> get onTheAir => [];
  
  @override
  RequestState get airingTodayState => RequestState.Empty;
  @override
  List<Tv> get airingToday => [];

  @override
  String get message => '';

  @override
  Future<void> fetchNowPlayingTv() async {}
  @override
  Future<void> fetchPopularTv() async {}
  @override
  Future<void> fetchTopRatedTv() async {}
  @override
  Future<void> fetchOnTheAirTv() async {}
  @override
  Future<void> fetchAiringTodayTv() async {}
}

class FakeWatchlistTvNotifier extends mocktail.Mock implements WatchlistTvNotifier {
  @override
  RequestState get watchlistState => RequestState.Empty;
  
  @override
  List<Tv> get watchlistTv => [];
  
  @override
  String get message => '';
  
  @override
  Future<void> fetchWatchlistTv() async {}
}
// Mocks needed for constructors
class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

class MockGetOnTheAirTv extends Mock implements GetOnTheAirTv {}

class MockGetAiringTodayTv extends Mock implements GetAiringTodayTv {}

    locator.registerLazySingleton<GetWatchlistTv>(() => MockGetWatchlistTv());
    locator.registerLazySingleton<SaveWatchlistTv>(() => MockSaveWatchlistTv());
    locator.registerLazySingleton<RemoveWatchlistTv>(
      () => MockRemoveWatchlistTv(),
    );
    locator.registerLazySingleton<SearchTv>(() => MockSearchTv());
    locator.registerLazySingleton<SearchMovies>(() => MockSearchMovies());
  });

  testWidgets('MyApp should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
