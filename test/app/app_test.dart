import 'dart:async';
import 'dart:io';

import 'package:ditonton/app/app.dart';
import 'package:ditonton/app/shell_cubit.dart';
import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:google_fonts/google_fonts.dart';

class MockShellCubit extends Mock implements ShellCubit {}

class MockThemeModeCubit extends Mock implements ThemeModeCubit {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

// Mock BLoCs
class MockNowPlayingMoviesBloc extends Mock implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc extends Mock implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc extends Mock implements TopRatedMoviesBloc {}

class MockMovieDetailBloc extends Mock implements MovieDetailBloc {}

class MockWatchlistMovieBloc extends Mock implements WatchlistMovieBloc {}

class MockMovieSearchBloc extends Mock implements MovieSearchBloc {}

class MockOnTheAirTvBloc extends Mock implements OnTheAirTvBloc {}

class MockAiringTodayTvBloc extends Mock implements AiringTodayTvBloc {}

class MockPopularTvBloc extends Mock implements PopularTvBloc {}

class MockTopRatedTvBloc extends Mock implements TopRatedTvBloc {}

class MockTvDetailBloc extends Mock implements TvDetailBloc {}

class MockTvSearchBloc extends Mock implements TvSearchBloc {}

class MockWatchlistTvBloc extends Mock implements WatchlistTvBloc {}

class MockSearchRecentCubit extends Mock implements SearchRecentCubit {}

class MockTvSearchRecentCubit extends Mock implements TvSearchRecentCubit {}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest();
  }
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }
}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => 404;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream.value(<int>[]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  late MockShellCubit mockShellCubit;
  late MockThemeModeCubit mockThemeModeCubit;
  late MockFirebaseAnalytics mockFirebaseAnalytics;
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  late MockOnTheAirTvBloc mockOnTheAirTvBloc;
  late MockAiringTodayTvBloc mockAiringTodayTvBloc;
  late MockPopularTvBloc mockPopularTvBloc;
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUp(() async {
    HttpOverrides.global = MockHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;
    await di.locator.reset();

    mockShellCubit = MockShellCubit();
    mockThemeModeCubit = MockThemeModeCubit();
    mockFirebaseAnalytics = MockFirebaseAnalytics();
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
    mockOnTheAirTvBloc = MockOnTheAirTvBloc();
    mockAiringTodayTvBloc = MockAiringTodayTvBloc();
    mockPopularTvBloc = MockPopularTvBloc();
    mockTopRatedTvBloc = MockTopRatedTvBloc();

    // FirebaseAnalytics
    when(
      () => mockFirebaseAnalytics.logScreenView(
        screenName: any(named: 'screenName'),
        screenClass: any(named: 'screenClass'),
        callOptions: any(named: 'callOptions'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockFirebaseAnalytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
        callOptions: any(named: 'callOptions'),
      ),
    ).thenAnswer((_) async {});

    // ShellCubit
    when(() => mockShellCubit.state).thenReturn(0);
    when(
      () => mockShellCubit.stream,
    ).thenAnswer((_) => StreamController<int>.broadcast().stream);
    when(() => mockShellCubit.close()).thenAnswer((_) async {});

    // ThemeModeCubit
    when(
      () => mockThemeModeCubit.state,
    ).thenReturn(const ThemeModeState(ThemeMode.system));
    when(
      () => mockThemeModeCubit.stream,
    ).thenAnswer((_) => StreamController<ThemeModeState>.broadcast().stream);
    when(() => mockThemeModeCubit.close()).thenAnswer((_) async {});

    // NowPlayingMoviesBloc
    when(
      () => mockNowPlayingMoviesBloc.state,
    ).thenReturn(NowPlayingMoviesEmpty());
    when(() => mockNowPlayingMoviesBloc.stream).thenAnswer(
      (_) => StreamController<NowPlayingMoviesState>.broadcast().stream,
    );
    when(() => mockNowPlayingMoviesBloc.close()).thenAnswer((_) async {});

    // PopularMoviesBloc
    when(() => mockPopularMoviesBloc.state).thenReturn(PopularMoviesEmpty());
    when(() => mockPopularMoviesBloc.stream).thenAnswer(
      (_) => StreamController<PopularMoviesState>.broadcast().stream,
    );
    when(() => mockPopularMoviesBloc.close()).thenAnswer((_) async {});

    // TopRatedMoviesBloc
    when(() => mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesEmpty());
    when(() => mockTopRatedMoviesBloc.stream).thenAnswer(
      (_) => StreamController<TopRatedMoviesState>.broadcast().stream,
    );
    when(() => mockTopRatedMoviesBloc.close()).thenAnswer((_) async {});

    // TV BLoCs
    when(() => mockOnTheAirTvBloc.state).thenReturn(OnTheAirTvInitial());
    when(
      () => mockOnTheAirTvBloc.stream,
    ).thenAnswer((_) => StreamController<OnTheAirTvState>.broadcast().stream);
    when(() => mockOnTheAirTvBloc.close()).thenAnswer((_) async {});

    when(() => mockAiringTodayTvBloc.state).thenReturn(AiringTodayTvInitial());
    when(() => mockAiringTodayTvBloc.stream).thenAnswer(
      (_) => StreamController<AiringTodayTvState>.broadcast().stream,
    );
    when(() => mockAiringTodayTvBloc.close()).thenAnswer((_) async {});

    when(() => mockPopularTvBloc.state).thenReturn(PopularTvInitial());
    when(
      () => mockPopularTvBloc.stream,
    ).thenAnswer((_) => StreamController<PopularTvState>.broadcast().stream);
    when(() => mockPopularTvBloc.close()).thenAnswer((_) async {});

    when(() => mockTopRatedTvBloc.state).thenReturn(TopRatedTvInitial());
    when(
      () => mockTopRatedTvBloc.stream,
    ).thenAnswer((_) => StreamController<TopRatedTvState>.broadcast().stream);
    when(() => mockTopRatedTvBloc.close()).thenAnswer((_) async {});
  });

  testWidgets('MyApp builds correctly', (tester) async {
    await tester.pumpWidget(
      MyApp(
        analytics: mockFirebaseAnalytics,
        providers: [
          BlocProvider<ShellCubit>(create: (_) => mockShellCubit),
          BlocProvider<ThemeModeCubit>(create: (_) => mockThemeModeCubit),
          BlocProvider<NowPlayingMoviesBloc>(
            create: (_) => mockNowPlayingMoviesBloc,
          ),
          BlocProvider<PopularMoviesBloc>(create: (_) => mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>(
            create: (_) => mockTopRatedMoviesBloc,
          ),
          BlocProvider<MovieDetailBloc>(create: (_) => MockMovieDetailBloc()),
          BlocProvider<WatchlistMovieBloc>(
            create: (_) => MockWatchlistMovieBloc(),
          ),
          BlocProvider<MovieSearchBloc>(create: (_) => MockMovieSearchBloc()),
          BlocProvider<OnTheAirTvBloc>(create: (_) => mockOnTheAirTvBloc),
          BlocProvider<AiringTodayTvBloc>(create: (_) => mockAiringTodayTvBloc),
          BlocProvider<PopularTvBloc>(create: (_) => mockPopularTvBloc),
          BlocProvider<TopRatedTvBloc>(create: (_) => mockTopRatedTvBloc),
          BlocProvider<TvDetailBloc>(create: (_) => MockTvDetailBloc()),
          BlocProvider<TvSearchBloc>(create: (_) => MockTvSearchBloc()),
          BlocProvider<WatchlistTvBloc>(create: (_) => MockWatchlistTvBloc()),
          BlocProvider<SearchRecentCubit>(
            create: (_) => MockSearchRecentCubit(),
          ),
          BlocProvider<TvSearchRecentCubit>(
            create: (_) => MockTvSearchRecentCubit(),
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(MyApp), findsOneWidget);
  });
}
