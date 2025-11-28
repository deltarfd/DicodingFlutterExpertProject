import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class GetWatchlistStatusTv {
  final TvRepository repository;
  GetWatchlistStatusTv(this.repository);
  Future<bool> execute(int id) => repository.isAddedToWatchlist(id);
}
