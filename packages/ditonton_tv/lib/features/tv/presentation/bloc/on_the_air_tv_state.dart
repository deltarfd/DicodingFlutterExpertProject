part of 'on_the_air_tv_bloc.dart';

abstract class OnTheAirTvState extends Equatable {
  const OnTheAirTvState();
  @override
  List<Object?> get props => [];
}

class OnTheAirTvInitial extends OnTheAirTvState {}

class OnTheAirTvLoading extends OnTheAirTvState {}

class OnTheAirTvLoaded extends OnTheAirTvState {
  final List<Tv> tvs;
  const OnTheAirTvLoaded(this.tvs);
  @override
  List<Object?> get props => [tvs];
}

class OnTheAirTvError extends OnTheAirTvState {
  final String message;
  const OnTheAirTvError(this.message);
  @override
  List<Object?> get props => [message];
}
