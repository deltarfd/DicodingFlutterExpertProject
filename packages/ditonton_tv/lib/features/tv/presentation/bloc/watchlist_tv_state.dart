import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvEmpty extends WatchlistTvState {}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvLoaded extends WatchlistTvState {
  final List<Tv> tvs;

  const WatchlistTvLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}
