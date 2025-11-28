part of 'popular_tv_bloc.dart';

abstract class PopularTvState extends Equatable {
  const PopularTvState();
  @override
  List<Object?> get props => [];
}

class PopularTvInitial extends PopularTvState {}

class PopularTvLoading extends PopularTvState {}

class PopularTvLoaded extends PopularTvState {
  final List<Tv> tvs;
  const PopularTvLoaded(this.tvs);
  @override
  List<Object?> get props => [tvs];
}

class PopularTvError extends PopularTvState {
  final String message;
  const PopularTvError(this.message);
  @override
  List<Object?> get props => [message];
}
