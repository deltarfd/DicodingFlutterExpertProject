part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();
  @override
  List<Object?> get props => [];
}

class SubmitTvQuery extends TvSearchEvent {
  final String query;
  const SubmitTvQuery(this.query);
  @override
  List<Object?> get props => [query];
}

class ClearTvQuery extends TvSearchEvent {
  const ClearTvQuery();
}
