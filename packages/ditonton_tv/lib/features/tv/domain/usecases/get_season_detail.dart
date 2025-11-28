import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class GetSeasonDetail {
  final TvRepository repository;
  GetSeasonDetail(this.repository);
  Future<Either<Failure, SeasonDetail>> execute(int tvId, int seasonNumber) =>
      repository.getSeasonDetail(tvId, seasonNumber);
}
