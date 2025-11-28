import 'package:bloc/bloc.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv searchTv;
  TvSearchBloc({required this.searchTv}) : super(TvSearchInitial()) {
    on<SubmitTvQuery>((event, emit) async {
      emit(TvSearchLoading());
      final result = await searchTv.execute(event.query);
      result.fold(
        (failure) => emit(TvSearchError(failure.message)),
        (data) => emit(TvSearchLoaded(data)),
      );
    });
    on<ClearTvQuery>((event, emit) => emit(TvSearchInitial()));
  }
}
