import 'package:equatable/equatable.dart';

abstract class TvSearchRecentState extends Equatable {
  const TvSearchRecentState();

  @override
  List<Object> get props => [];
}

class TvSearchRecentInitial extends TvSearchRecentState {
  const TvSearchRecentInitial();
}

class TvSearchRecentLoaded extends TvSearchRecentState {
  final List<String> searches;

  const TvSearchRecentLoaded(this.searches);

  @override
  List<Object> get props => [searches];
}
