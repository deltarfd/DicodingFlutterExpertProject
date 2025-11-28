part of 'airing_today_tv_bloc.dart';

abstract class AiringTodayTvState extends Equatable {
  const AiringTodayTvState();
  @override
  List<Object?> get props => [];
}

class AiringTodayTvInitial extends AiringTodayTvState {}

class AiringTodayTvLoading extends AiringTodayTvState {}

class AiringTodayTvLoaded extends AiringTodayTvState {
  final List<Tv> tvs;
  const AiringTodayTvLoaded(this.tvs);
  @override
  List<Object?> get props => [tvs];
}

class AiringTodayTvError extends AiringTodayTvState {
  final String message;
  const AiringTodayTvError(this.message);
  @override
  List<Object?> get props => [message];
}
