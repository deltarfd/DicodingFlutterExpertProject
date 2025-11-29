import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_state.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movies_page_loading_test.mocks.dart';

@GenerateMocks([WatchlistMovieBloc])
void main() {
  testWidgets('Watchlist shows loading skeleton first', (tester) async {
    final mockBloc = MockWatchlistMovieBloc();

    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          WatchlistMovieLoading(),
          const WatchlistMovieLoaded([]),
        ]));
    when(mockBloc.state).thenReturn(WatchlistMovieLoading());

    await tester.pumpWidget(MaterialApp(
      navigatorObservers: [routeObserver],
      home: BlocProvider<WatchlistMovieBloc>.value(
        value: mockBloc,
        child: const WatchlistMoviesPage(),
      ),
    ));

    // Should see loading state (ListView with skeleton)
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(ListView), findsOneWidget);

    // Let state transition complete
    await tester.pump(const Duration(milliseconds: 100));
  });
}
