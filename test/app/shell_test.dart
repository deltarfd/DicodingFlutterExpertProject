import 'dart:async';
import 'dart:io';

import 'package:ditonton/app/shell.dart';
import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:google_fonts/google_fonts.dart';

class MockThemeModeCubit extends Mock implements ThemeModeCubit {}

// Mock BLoCs
class MockNowPlayingMoviesBloc extends Mock implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc extends Mock implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc extends Mock implements TopRatedMoviesBloc {}

class MockOnTheAirTvBloc extends Mock implements OnTheAirTvBloc {}

class MockAiringTodayTvBloc extends Mock implements AiringTodayTvBloc {}

class MockPopularTvBloc extends Mock implements PopularTvBloc {}

class MockTopRatedTvBloc extends Mock implements TopRatedTvBloc {}

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
  late MockThemeModeCubit mockThemeModeCubit;
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  late MockOnTheAirTvBloc mockOnTheAirTvBloc;
  late MockAiringTodayTvBloc mockAiringTodayTvBloc;
  late MockPopularTvBloc mockPopularTvBloc;
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUp(() {
    HttpOverrides.global = MockHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;

    mockThemeModeCubit = MockThemeModeCubit();
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
    mockOnTheAirTvBloc = MockOnTheAirTvBloc();
    mockAiringTodayTvBloc = MockAiringTodayTvBloc();
    mockPopularTvBloc = MockPopularTvBloc();
    mockTopRatedTvBloc = MockTopRatedTvBloc();

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

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeCubit>.value(value: mockThemeModeCubit),
        BlocProvider<NowPlayingMoviesBloc>.value(
          value: mockNowPlayingMoviesBloc,
        ),
        BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedMoviesBloc),
        BlocProvider<OnTheAirTvBloc>.value(value: mockOnTheAirTvBloc),
        BlocProvider<AiringTodayTvBloc>.value(value: mockAiringTodayTvBloc),
        BlocProvider<PopularTvBloc>.value(value: mockPopularTvBloc),
        BlocProvider<TopRatedTvBloc>.value(value: mockTopRatedTvBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('AppShell builds correctly and navigates', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const AppShell()));
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Movies'), findsWidgets);
    expect(find.text('TV'), findsWidgets);
    expect(find.text('About'), findsOneWidget);

    // Navigate to TV
    await tester.tap(find.text('TV').last);
    await tester.pumpAndSettle();

    // Navigate to About
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
  });

  testWidgets('AppShell FAB toggles theme', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const AppShell()));
    await tester.pump();

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    verify(() => mockThemeModeCubit.toggle()).called(1);
  });
}
