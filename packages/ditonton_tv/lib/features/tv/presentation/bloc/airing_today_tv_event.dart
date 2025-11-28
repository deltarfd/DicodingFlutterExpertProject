part of 'airing_today_tv_bloc.dart';

abstract class AiringTodayTvEvent extends Equatable {
  const AiringTodayTvEvent();
  @override
  List<Object?> get props => [];
}

class FetchAiringTodayTv extends AiringTodayTvEvent {}
