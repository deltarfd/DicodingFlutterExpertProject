import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements TvRepository {}

void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
  });

  group('Usecases - simple forwards', () {
    test('GetOnTheAirTv returns list', () async {
      when(() => repo.getOnTheAirTv()).thenAnswer((_) async => const Right(<Tv>[]));
      final uc = GetOnTheAirTv(repo);
      final res = await uc.execute();
      expect(res.isRight(), true);
      verify(() => repo.getOnTheAirTv()).called(1);
    });

    test('GetTopRatedTv returns list and failure', () async {
      when(() => repo.getTopRatedTv()).thenAnswer((_) async => const Right(<Tv>[]));
      final uc = GetTopRatedTv(repo);
      expect((await uc.execute()).isRight(), true);
      when(() => repo.getTopRatedTv()).thenAnswer((_) async => const Left(ServerFailure('err')));
      final res2 = await uc.execute();
      expect(res2.isLeft(), true);
    });

    test('GetTvDetail returns detail', () async {
      when(() => repo.getTvDetail(1)).thenAnswer((_) async => Right(const TvDetail(
            id: 1,
            name: 'N',
            overview: 'O',
            posterPath: null,
            voteAverage: 0,
            genres: [],
            seasons: [],
          )));
      final uc = GetTvDetail(repo);
      final res = await uc.execute(1);
      expect(res.isRight(), true);
      verify(() => repo.getTvDetail(1)).called(1);
    });

    test('GetTvRecommendations returns list', () async {
      when(() => repo.getTvRecommendations(1)).thenAnswer((_) async => const Right(<Tv>[]));
      final uc = GetTvRecommendations(repo);
      final res = await uc.execute(1);
      expect(res.isRight(), true);
      verify(() => repo.getTvRecommendations(1)).called(1);
    });

    test('GetWatchlistStatusTv returns bool', () async {
      when(() => repo.isAddedToWatchlist(1)).thenAnswer((_) async => true);
      final uc = GetWatchlistStatusTv(repo);
      final res = await uc.execute(1);
      expect(res, true);
      verify(() => repo.isAddedToWatchlist(1)).called(1);
    });

    test('GetWatchlistTv returns list', () async {
      when(() => repo.getWatchlistTv()).thenAnswer((_) async => const Right(<Tv>[]));
      final uc = GetWatchlistTv(repo);
      final res = await uc.execute();
      expect(res.isRight(), true);
      verify(() => repo.getWatchlistTv()).called(1);
    });

    test('SaveWatchlistTv and RemoveWatchlistTv forward messages', () async {
      final detail = const TvDetail(
        id: 2,
        name: 'N',
        overview: 'O',
        posterPath: null,
        voteAverage: 0,
        genres: [],
        seasons: [],
      );
      when(() => repo.saveWatchlist(detail)).thenAnswer((_) async => const Right('ok'));
      when(() => repo.removeWatchlist(detail)).thenAnswer((_) async => const Right('ok'));
      final saveUc = SaveWatchlistTv(repo);
      final remUc = RemoveWatchlistTv(repo);
      expect((await saveUc.execute(detail)).getOrElse(() => ''), 'ok');
      expect((await remUc.execute(detail)).getOrElse(() => ''), 'ok');
      verify(() => repo.saveWatchlist(detail)).called(1);
      verify(() => repo.removeWatchlist(detail)).called(1);
    });

    test('GetSeasonDetail returns episodes', () async {
      when(() => repo.getSeasonDetail(1, 1)).thenAnswer((_) async => Right(SeasonDetail(
            id: 1,
            seasonNumber: 1,
            episodes: const [Episode(id: 1, name: 'E1', episodeNumber: 1, overview: '', stillPath: null)],
          )));
      final uc = GetSeasonDetail(repo);
      final res = await uc.execute(1, 1);
      expect(res.isRight(), true);
      verify(() => repo.getSeasonDetail(1, 1)).called(1);
    });
  });
}
