import 'package:bloc/bloc.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc(this.getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchlistMovieError(failure.message));
        },
        (data) {
          emit(WatchlistMovieLoaded(data));
        },
      );
    });
  }
}
