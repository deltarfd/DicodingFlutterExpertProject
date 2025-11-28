import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:equatable/equatable.dart';

class SeasonDetail extends Equatable {
  final int id;
  final int seasonNumber;
  final List<Episode> episodes;

  const SeasonDetail({
    required this.id,
    required this.seasonNumber,
    required this.episodes,
  });

  @override
  List<Object?> get props => [id, seasonNumber, episodes];
}
