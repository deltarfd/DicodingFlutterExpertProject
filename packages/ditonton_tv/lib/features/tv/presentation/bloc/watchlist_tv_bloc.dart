import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_event.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlistTv;

  WatchlistTvBloc(this.getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await getWatchlistTv.execute();

      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (data) {
          emit(WatchlistTvLoaded(data));
        },
      );
    });
  }
}
