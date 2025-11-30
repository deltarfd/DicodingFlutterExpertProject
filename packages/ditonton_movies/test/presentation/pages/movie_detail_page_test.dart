import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_state.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final movieDetailBloc = MockMovieDetailBloc();
    final controller = StreamController<MovieDetailState>.broadcast();
    addTearDown(controller.close);

    when(movieDetailBloc.stream).thenAnswer((_) => controller.stream);
    when(movieDetailBloc.state).thenReturn(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(BlocProvider<MovieDetailBloc>.value(
      value: movieDetailBloc,
      child: MaterialApp(
        home: const MovieDetailPage(id: 1),
      ),
    ));

    expect(find.byIcon(Icons.add), findsOneWidget);

    // Trigger state change
    await tester.tap(watchlistButton);

    controller.add(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
      watchlistMessage: 'Added to Watchlist',
    ));

    await tester.pump(); // Process state change
    await tester.pump(const Duration(milliseconds: 100)); // Animation

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when add to watchlist failed',
      (WidgetTester tester) async {
    final movieDetailBloc = MockMovieDetailBloc();
    final controller = StreamController<MovieDetailState>.broadcast();
    addTearDown(controller.close);

    when(movieDetailBloc.stream).thenAnswer((_) => controller.stream);
    when(movieDetailBloc.state).thenReturn(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(BlocProvider<MovieDetailBloc>.value(
      value: movieDetailBloc,
      child: MaterialApp(
        home: const MovieDetailPage(id: 1),
      ),
    ));

    expect(find.byIcon(Icons.add), findsOneWidget);

    // Trigger state change
    await tester.tap(watchlistButton);

    controller.add(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
      watchlistMessage: 'Failed',
    ));

    await tester.pump(); // Process state change
    await tester.pump(const Duration(milliseconds: 100)); // Animation

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Shows recommendation error message branch',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.error,
      message: 'Recs failed',
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Recs failed'), findsOneWidget);
  });

  testWidgets('Tapping a recommendation pushes replacement with id',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(MovieDetailState.initial().copyWith(
      movieDetailStatus: MovieDetailStatus.loaded,
      movieDetail: testMovieDetail,
      movieRecommendations: <Movie>[
        const Movie(
          adult: false,
          backdropPath: 'b',
          genreIds: [],
          id: 99,
          originalTitle: 'OT',
          overview: 'OV',
          popularity: 0,
          posterPath: '/p',
          releaseDate: '2020-01-01',
          title: 'R',
          video: false,
          voteAverage: 0,
          voteCount: 0,
        )
      ],
      isAddedToWatchlist: false,
    ));

    int? navigatedId;
    Widget makeRouter(Widget body) {
      return BlocProvider<MovieDetailBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          onGenerateRoute: (settings) {
            if (settings.name == MovieDetailPage.ROUTE_NAME) {
              navigatedId = settings.arguments as int?;
              return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
            }
            return MaterialPageRoute(builder: (_) => body);
          },
        ),
      );
    }

    await tester.pumpWidget(makeRouter(const MovieDetailPage(id: 1)));
    await tester.pump();

    // Tap first recommendation InkWell inside the horizontal list
    final recInk = find
        .descendant(
          of: find.byType(ListView),
          matching: find.byType(InkWell),
        )
        .first;
    // Call the onTap directly to avoid hit-test issues in DraggableScrollableSheet
    final ink = tester.widget<InkWell>(recInk);
    ink.onTap!.call();
    await tester.pump();

    expect(navigatedId, 99);
  });
}
