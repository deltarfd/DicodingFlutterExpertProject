part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchTvDetailEvent extends TvDetailEvent {
  final int id;
  const FetchTvDetailEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleWatchlistEvent extends TvDetailEvent {}
