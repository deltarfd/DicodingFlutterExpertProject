import 'package:equatable/equatable.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTv extends WatchlistTvEvent {}
