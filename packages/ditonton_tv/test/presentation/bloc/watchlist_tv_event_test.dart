import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Watchlist Tv Events', () {
    test('FetchWatchlistTv should have correct props', () {
      expect(FetchWatchlistTv().props, []);
    });

    test('FetchWatchlistTv instances should be equal', () {
      expect(FetchWatchlistTv(), equals(FetchWatchlistTv()));
    });
  });
}
