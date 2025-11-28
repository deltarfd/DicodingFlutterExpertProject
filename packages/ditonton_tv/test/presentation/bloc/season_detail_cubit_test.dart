import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/season_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'season_detail_cubit_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late SeasonDetailCubit cubit;
  late MockGetSeasonDetail mockGetSeasonDetail;

  const tTvId = 1;
  const tSeasonNumber = 1;
  const tEpisodes = [
    Episode(
      id: 1,
      episodeNumber: 1,
      name: 'Episode 1',
      overview: 'Overview 1',
      stillPath: '/path1.jpg',
    ),
    Episode(
      id: 2,
      episodeNumber: 2,
      name: 'Episode 2',
      overview: 'Overview 2',
      stillPath: '/path2.jpg',
    ),
  ];
  const tSeasonDetail = SeasonDetail(
    id: 1,
    seasonNumber: tSeasonNumber,
    episodes: tEpisodes,
  );

  setUp(() {
    mockGetSeasonDetail = MockGetSeasonDetail();
    cubit = SeasonDetailCubit(
      getSeasonDetail: mockGetSeasonDetail,
      tvId: tTvId,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be SeasonDetailState.initial', () {
    expect(cubit.state, const SeasonDetailState.initial());
  });

  blocTest<SeasonDetailCubit, SeasonDetailState>(
    'should emit [loading, loaded] when fetch is successful',
    build: () {
      when(
        mockGetSeasonDetail.execute(tTvId, tSeasonNumber),
      ).thenAnswer((_) async => const Right(tSeasonDetail));
      return cubit;
    },
    act: (cubit) => cubit.fetch(tSeasonNumber),
    expect: () => [
      const SeasonDetailState.loading(),
      const SeasonDetailState.loaded(tEpisodes),
    ],
    verify: (_) {
      verify(mockGetSeasonDetail.execute(tTvId, tSeasonNumber));
    },
  );

  blocTest<SeasonDetailCubit, SeasonDetailState>(
    'should emit [loading, error] when fetch fails',
    build: () {
      when(
        mockGetSeasonDetail.execute(tTvId, tSeasonNumber),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
      return cubit;
    },
    act: (cubit) => cubit.fetch(tSeasonNumber),
    expect: () => [
      const SeasonDetailState.loading(),
      const SeasonDetailState.error('Server Error'),
    ],
    verify: (_) {
      verify(mockGetSeasonDetail.execute(tTvId, tSeasonNumber));
    },
  );

  test('should use cache when fetching same season twice', () async {
    when(
      mockGetSeasonDetail.execute(tTvId, tSeasonNumber),
    ).thenAnswer((_) async => const Right(tSeasonDetail));

    await cubit.fetch(tSeasonNumber);
    await cubit.fetch(tSeasonNumber);

    verify(mockGetSeasonDetail.execute(tTvId, tSeasonNumber)).called(1);
  });
}
