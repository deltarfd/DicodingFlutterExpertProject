import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistStatusTv getWatchlistStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchlistStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(TvDetailState.initial()) {
    on<FetchTvDetailEvent>((event, emit) async {
      emit(state.copyWith(status: TvDetailStatus.loading));

      final detailResult = await getTvDetail.execute(event.id);
      if (detailResult.isLeft()) {
        detailResult.fold(
          (failure) => emit(state.copyWith(
              status: TvDetailStatus.error, message: failure.message)),
          (_) {},
        );
        return;
      }

      late TvDetail detail;
      detailResult.fold((_) {}, (d) => detail = d);

      final recResult = await getTvRecommendations.execute(event.id);
      final recs = recResult.fold((_) => <Tv>[], (r) => r);
      final isInWatchlist = await getWatchlistStatusTv.execute(event.id);

      emit(state.copyWith(
        status: TvDetailStatus.loaded,
        detail: detail,
        recommendations: recs,
        isInWatchlist: isInWatchlist,
      ));
    });

    on<ToggleWatchlistEvent>((event, emit) async {
      if (state.detail == null) return;
      final tv = state.detail!;
      final result = state.isInWatchlist
          ? await removeWatchlistTv.execute(tv)
          : await saveWatchlistTv.execute(tv);

      if (result.isLeft()) {
        final failureMessage =
            result.fold((failure) => failure.message, (_) => '');
        emit(state.copyWith(message: failureMessage));
        return;
      }

      final message = result.fold((_) => '', (r) => r);
      final status = await getWatchlistStatusTv.execute(tv.id);
      emit(state.copyWith(isInWatchlist: status, message: message));
    });
  }
}
