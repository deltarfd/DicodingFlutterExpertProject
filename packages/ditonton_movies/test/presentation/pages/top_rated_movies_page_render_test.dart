import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_render_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  testWidgets('Top rated page renders MovieCard when loaded with data',
      (tester) async {
    final mockBloc = MockTopRatedMoviesBloc();
    const testMovieList = [
      Movie(
        adult: false,
        backdropPath: 'b',
        genreIds: [],
        id: 2,
        originalTitle: 'OT',
        overview: 'OV',
        popularity: 0,
        posterPath: '/p',
        releaseDate: '2020-01-01',
        title: 'TR',
        video: false,
        voteAverage: 0,
        voteCount: 0,
      )
    ];

    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(const TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: const MaterialApp(home: TopRatedMoviesPage()),
    ));

    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('TR'), findsOneWidget);
  });
}
