import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class GetTopRatedTv {
  final TvRepository repository;
  GetTopRatedTv(this.repository);
  Future<Either<Failure, List<Tv>>> execute() => repository.getTopRatedTv();
}
