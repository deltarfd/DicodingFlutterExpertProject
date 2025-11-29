import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_state.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieBloc])
void main() {
  late MockWatchlistMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        home: body,
      ),
    );
  }

  testWidgets('Watchlist shows list when loaded', (tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(WatchlistMovieLoaded([testWatchlistMovie]));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Watchlist shows error message', (tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state).thenReturn(const WatchlistMovieError('oops'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
