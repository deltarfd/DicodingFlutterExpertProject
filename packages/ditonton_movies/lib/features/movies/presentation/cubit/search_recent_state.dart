import 'package:equatable/equatable.dart';

abstract class SearchRecentState extends Equatable {
  const SearchRecentState();

  @override
  List<Object> get props => [];
}

class SearchRecentInitial extends SearchRecentState {
  const SearchRecentInitial();
}

class SearchRecentLoaded extends SearchRecentState {
  final List<String> searches;

  const SearchRecentLoaded(this.searches);

  @override
  List<Object> get props => [searches];
}
