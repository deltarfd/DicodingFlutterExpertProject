import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv getPopularTv;
  PopularTvBloc({required this.getPopularTv}) : super(PopularTvInitial()) {
    on<FetchPopularTv>((event, emit) async {
      emit(PopularTvLoading());
      final result = await getPopularTv.execute();
      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
        (data) => emit(PopularTvLoaded(data)),
      );
    });
  }
}
