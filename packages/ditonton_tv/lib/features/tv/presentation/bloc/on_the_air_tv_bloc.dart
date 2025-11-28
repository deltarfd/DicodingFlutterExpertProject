import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tv_event.dart';
part 'on_the_air_tv_state.dart';

class OnTheAirTvBloc extends Bloc<OnTheAirTvEvent, OnTheAirTvState> {
  final GetOnTheAirTv getOnTheAirTv;
  OnTheAirTvBloc({required this.getOnTheAirTv}) : super(OnTheAirTvInitial()) {
    on<FetchOnTheAirTv>((event, emit) async {
      emit(OnTheAirTvLoading());
      final result = await getOnTheAirTv.execute();
      result.fold(
        (failure) => emit(OnTheAirTvError(failure.message)),
        (data) => emit(OnTheAirTvLoaded(data)),
      );
    });
  }
}
