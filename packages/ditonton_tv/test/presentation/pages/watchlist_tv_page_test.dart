import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/watchlist_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'watchlist_tv_page_test.mocks.dart';

@GenerateMocks([WatchlistTvNotifier])
void main() {
  late MockWatchlistTvNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      home: ChangeNotifierProvider<WatchlistTvNotifier>.value(
        value: mockNotifier,
        child: body,
      ),
    );
  }

  testWidgets('WatchlistTvPage can be instantiated', (tester) async {
    const page = WatchlistTvPage();
    expect(page, isA<StatefulWidget>());
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);
    when(mockNotifier.watchlistTv).thenReturn([]);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show TV list when state is loaded', (tester) async {
    final tvList = [
      const Tv(
        id: 1,
        name: 'TV 1',
        overview: 'Overview 1',
        posterPath: '/path1.jpg',
        voteAverage: 8.0,
      ),
      const Tv(
        id: 2,
        name: 'TV 2',
        overview: 'Overview 2',
        posterPath: '/path2.jpg',
        voteAverage: 7.5,
      ),
    ];

    when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
    when(mockNotifier.watchlistTv).thenReturn(tvList);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCardList), findsNWidgets(2));
  });

  testWidgets('should show error message when state is error', (tester) async {
    const errorMessage = 'Failed to load watchlist';

    when(mockNotifier.watchlistState).thenReturn(RequestState.Error);
    when(mockNotifier.watchlistTv).thenReturn([]);
    when(mockNotifier.message).thenReturn(errorMessage);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should show AppBar with correct title', (tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);
    when(mockNotifier.watchlistTv).thenReturn([]);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Watchlist TV'), findsOneWidget);
  });

  testWidgets('should call fetchWatchlistTv on init', (tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);
    when(mockNotifier.watchlistTv).thenReturn([]);
    when(mockNotifier.fetchWatchlistTv()).thenAnswer((_) async => {});

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvPage()));
    await tester.pump(Duration.zero);

    verify(mockNotifier.fetchWatchlistTv()).called(1);
  });

  testWidgets('should show empty list when watchlist is empty', (tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
    when(mockNotifier.watchlistTv).thenReturn([]);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCardList), findsNothing);
  });
}
