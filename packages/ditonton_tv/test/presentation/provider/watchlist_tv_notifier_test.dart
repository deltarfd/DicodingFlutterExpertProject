import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvNotifier notifier;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    notifier = WatchlistTvNotifier(getWatchlistTv: mockGetWatchlistTv);
  });

  final tTvList = [
    const Tv(
      id: 1,
      name: 'Name',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
    ),
  ];

  test('initial state should be empty', () {
    expect(notifier.watchlistState, RequestState.Empty);
    expect(notifier.watchlistTv, []);
    expect(notifier.message, '');
  });

  test('should change state to loading when fetching watchlist', () async {
    // arrange
    when(mockGetWatchlistTv.execute()).thenAnswer((_) async => Right(tTvList));

    // act
    notifier.fetchWatchlistTv();

    // assert
    expect(notifier.watchlistState, RequestState.Loading);
  });

  test('should change watchlist data when fetch is successful', () async {
    // arrange
    when(mockGetWatchlistTv.execute()).thenAnswer((_) async => Right(tTvList));

    // act
    await notifier.fetchWatchlistTv();

    // assert
    expect(notifier.watchlistState, RequestState.Loaded);
    expect(notifier.watchlistTv, tTvList);
  });

  test('should return error when fetch fails', () async {
    // arrange
    when(
      mockGetWatchlistTv.execute(),
    ).thenAnswer((_) async => const Left(DatabaseFailure('Database Failure')));

    // act
    await notifier.fetchWatchlistTv();

    // assert
    expect(notifier.watchlistState, RequestState.Error);
    expect(notifier.message, 'Database Failure');
  });
}
