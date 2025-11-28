import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_notifier_coverage_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchlistStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  GetSeasonDetail,
])
void main() {
  late TvDetailNotifier notifier;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTv mockGetWatchlistStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late MockGetSeasonDetail mockGetSeasonDetail;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatusTv = MockGetWatchlistStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    mockGetSeasonDetail = MockGetSeasonDetail();

    notifier = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchlistStatusTv: mockGetWatchlistStatusTv,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
      getSeasonDetail: mockGetSeasonDetail,
    );
  });

  const tId = 1;
  const tTvDetail = TvDetail(
    id: tId,
    name: 'Name',
    overview: 'Overview',
    posterPath: 'Poster',
    voteAverage: 1.0,
    genres: [],
    seasons: [],
  );
  const tTv = Tv(
    id: 1,
    name: 'Name',
    overview: 'Overview',
    posterPath: 'Poster',
    voteAverage: 1.0,
  );
  final tTvList = <Tv>[tTv];

  group('Get Tv Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => const Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      await notifier.fetchTvDetail(tId);
      // assert
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when request is getting data', () {
      // arrange
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => const Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      notifier.fetchTvDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => const Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      await notifier.fetchTvDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Loaded);
      expect(notifier.tv, tTvDetail);
    });

    test(
      'should change recommendation when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => const Right(tTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tTvList));
        // act
        await notifier.fetchTvDetail(tId);
        // assert
        expect(notifier.recommendationState, RequestState.Loaded);
        expect(notifier.recommendations, tTvList);
      },
    );

    test('should return error when get detail is unsuccessful', () async {
      // arrange
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      await notifier.fetchTvDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
    });

    test(
      'should return error when get recommendation is unsuccessful',
      () async {
        // arrange
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => const Right(tTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        // act
        await notifier.fetchTvDetail(tId);
        // assert
        expect(notifier.recommendationState, RequestState.Error);
        expect(notifier.message, 'Server Failure');
      },
    );
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatusTv.execute(1)).thenAnswer((_) async => true);
      // act
      await notifier.loadWatchlistStatus(1);
      // assert
      expect(notifier.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(
        mockSaveWatchlistTv.execute(tTvDetail),
      ).thenAnswer((_) async => const Right('Success'));
      when(
        mockGetWatchlistStatusTv.execute(tTvDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await notifier.addWatchlist(tTvDetail);
      // assert
      verify(mockSaveWatchlistTv.execute(tTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(
        mockRemoveWatchlistTv.execute(tTvDetail),
      ).thenAnswer((_) async => const Right('Removed'));
      when(
        mockGetWatchlistStatusTv.execute(tTvDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await notifier.removeFromWatchlist(tTvDetail);
      // assert
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(
        mockSaveWatchlistTv.execute(tTvDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        mockGetWatchlistStatusTv.execute(tTvDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await notifier.addWatchlist(tTvDetail);
      // assert
      expect(notifier.watchlistMessage, 'Added to Watchlist');
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(
        mockSaveWatchlistTv.execute(tTvDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistStatusTv.execute(tTvDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await notifier.addWatchlist(tTvDetail);
      // assert
      expect(notifier.watchlistMessage, 'Failed');
    });

    test(
      'should update watchlist message when remove watchlist failed',
      () async {
        // arrange
        when(
          mockRemoveWatchlistTv.execute(tTvDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(
          mockGetWatchlistStatusTv.execute(tTvDetail.id),
        ).thenAnswer((_) async => false);
        // act
        await notifier.removeFromWatchlist(tTvDetail);
        // assert
        expect(notifier.watchlistMessage, 'Failed');
      },
    );
  });

  group('Season Episodes', () {
    test('should fetch season episodes', () async {
      // arrange
      // We need to set _tv first because fetchSeasonEpisodes uses tv.id
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => const Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      await notifier.fetchTvDetail(tId);

      when(mockGetSeasonDetail.execute(tId, 1)).thenAnswer(
        (_) async =>
            const Right(SeasonDetail(id: 1, seasonNumber: 1, episodes: [])),
      );

      // act
      await notifier.fetchSeasonEpisodes(1);

      // assert
      expect(notifier.seasonEpisodes.containsKey(1), true);
    });

    test('should return error when fetch season episodes failed', () async {
      // arrange
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => const Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      await notifier.fetchTvDetail(tId);

      when(
        mockGetSeasonDetail.execute(tId, 1),
      ).thenAnswer((_) async => const Left(ServerFailure('Failed')));

      // act
      await notifier.fetchSeasonEpisodes(1);

      // assert
      expect(notifier.message, 'Failed');
    });
  });
}
