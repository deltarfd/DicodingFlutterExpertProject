import 'package:bloc/bloc.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies)
      : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowPlayingMoviesLoading());
      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(NowPlayingMoviesError(failure.message));
        },
        (data) {
          emit(NowPlayingMoviesLoaded(data));
        },
      );
    });
  }
}
