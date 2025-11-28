import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class GetTvDetail {
  final TvRepository repository;
  GetTvDetail(this.repository);
  Future<Either<Failure, TvDetail>> execute(int id) =>
      repository.getTvDetail(id);
}
