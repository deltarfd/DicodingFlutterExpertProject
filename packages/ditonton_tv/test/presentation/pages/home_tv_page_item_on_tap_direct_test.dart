import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repo implements TvRepository {
  final List<Tv> tvs;
  _Repo(this.tvs);
  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTv() async => Right(tvs);
  @override
  Future<Either<Failure, List<Tv>>> getAiringTodayTv() async => const Right([]);
  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async => const Right([]);
  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async => const Right([]);
  // Unused
  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async => throw UnimplementedError();
  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async => throw UnimplementedError();
  @override
  Future<bool> isAddedToWatchlist(int id) async => throw UnimplementedError();
  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async => const Right([]);
  @override
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(int tvId, int seasonNumber) async =>
      Right(const SeasonDetail(id: 0, seasonNumber: 1, episodes: []));
  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() async => const Right([]);
}

void main() {
  testWidgets('HomeTvPage list item onTap pushes detail', (tester) async {
    final tv = const Tv(id: 7, name: 'N', overview: 'O', posterPath: '/p', voteAverage: 8.0);
    int? navigatedId;

    final repo = _Repo([tv]);
    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnTheAirTvBloc(getOnTheAirTv: GetOnTheAirTv(repo))),
      ),
    ));

    await tester.pump(const Duration(milliseconds: 200));
    final inkwell = find.byType(InkWell).first;
    await tester.tap(inkwell);
    await tester.pump();
    expect(navigatedId, tv.id);
  });
}
