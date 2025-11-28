import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:equatable/equatable.dart';

part 'airing_today_tv_event.dart';
part 'airing_today_tv_state.dart';

class AiringTodayTvBloc extends Bloc<AiringTodayTvEvent, AiringTodayTvState> {
  final GetAiringTodayTv getAiringTodayTv;
  AiringTodayTvBloc({required this.getAiringTodayTv})
      : super(AiringTodayTvInitial()) {
    on<FetchAiringTodayTv>((event, emit) async {
      emit(AiringTodayTvLoading());
      final result = await getAiringTodayTv.execute();
      result.fold(
        (failure) => emit(AiringTodayTvError(failure.message)),
        (data) => emit(AiringTodayTvLoaded(data)),
      );
    });
  }
}
