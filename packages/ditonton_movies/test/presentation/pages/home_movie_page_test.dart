import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([
  NowPlayingMoviesBloc,
  PopularMoviesBloc,
  TopRatedMoviesBloc,
])
void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(
          value: mockNowPlayingMoviesBloc,
        ),
        BlocProvider<PopularMoviesBloc>.value(
          value: mockPopularMoviesBloc,
        ),
        BlocProvider<TopRatedMoviesBloc>.value(
          value: mockTopRatedMoviesBloc,
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        home: body,
      ),
    );
  }

  testWidgets('HomeMoviePage shows lists when loaded', (tester) async {
    when(mockNowPlayingMoviesBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));

    when(mockPopularMoviesBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));

    when(mockTopRatedMoviesBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(InkWell), findsWidgets);
  });

  testWidgets('HomeMoviePage shows error text on failures', (tester) async {
    when(mockNowPlayingMoviesBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(mockNowPlayingMoviesBloc.state)
        .thenReturn(const NowPlayingMoviesError('Failed'));

    when(mockPopularMoviesBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockPopularMoviesBloc.state)
        .thenReturn(const PopularMoviesError('Failed'));

    when(mockTopRatedMoviesBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockTopRatedMoviesBloc.state)
        .thenReturn(const TopRatedMoviesError('Failed'));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));
    await tester.pump();

    expect(find.text('Failed'), findsWidgets);
  });
}
