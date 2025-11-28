part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();
  @override
  List<Object?> get props => [];
}

class TopRatedTvInitial extends TopRatedTvState {}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvLoaded extends TopRatedTvState {
  final List<Tv> tvs;
  const TopRatedTvLoaded(this.tvs);
  @override
  List<Object?> get props => [tvs];
}

class TopRatedTvError extends TopRatedTvState {
  final String message;
  const TopRatedTvError(this.message);
  @override
  List<Object?> get props => [message];
}
