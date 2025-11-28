import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;
  GetTvRecommendations(this.repository);
  Future<Either<Failure, List<Tv>>> execute(int id) =>
      repository.getTvRecommendations(id);
}
