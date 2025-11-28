part of 'season_detail_cubit.dart';

class SeasonDetailState extends Equatable {
  final bool loading;
  final List<Episode> episodes;
  final String message;

  const SeasonDetailState(
      {required this.loading, required this.episodes, required this.message});
  const SeasonDetailState.initial()
      : this(loading: false, episodes: const [], message: '');
  const SeasonDetailState.loading()
      : this(loading: true, episodes: const [], message: '');
  const SeasonDetailState.error(String message)
      : this(loading: false, episodes: const [], message: message);
  const SeasonDetailState.loaded(List<Episode> episodes)
      : this(loading: false, episodes: episodes, message: '');

  @override
  List<Object?> get props => [loading, episodes, message];
}
