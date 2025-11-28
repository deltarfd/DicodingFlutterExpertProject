import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:equatable/equatable.dart';

part 'season_detail_state.dart';

class SeasonDetailCubit extends Cubit<SeasonDetailState> {
  final GetSeasonDetail getSeasonDetail;
  final int tvId;

  // Cache per seasonNumber to avoid duplicate calls
  final Map<int, List<Episode>> _cache = {};

  SeasonDetailCubit({required this.getSeasonDetail, required this.tvId})
      : super(const SeasonDetailState.initial());

  Future<void> fetch(int seasonNumber) async {
    if (_cache.containsKey(seasonNumber)) {
      emit(SeasonDetailState.loaded(_cache[seasonNumber]!));
      return;
    }
    emit(const SeasonDetailState.loading());
    final result = await getSeasonDetail.execute(tvId, seasonNumber);
    result.fold(
      (failure) => emit(SeasonDetailState.error(failure.message)),
      (detail) {
        _cache[seasonNumber] = detail.episodes;
        emit(SeasonDetailState.loaded(detail.episodes));
      },
    );
  }
}
