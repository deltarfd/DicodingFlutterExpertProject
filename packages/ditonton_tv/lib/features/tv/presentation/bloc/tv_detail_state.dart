part of 'tv_detail_bloc.dart';

enum TvDetailStatus { initial, loading, loaded, error }

class TvDetailState extends Equatable {
  final TvDetailStatus status;
  final TvDetail? detail;
  final List<Tv> recommendations;
  final bool isInWatchlist;
  final String message;

  const TvDetailState({
    required this.status,
    required this.detail,
    required this.recommendations,
    required this.isInWatchlist,
    required this.message,
  });

  factory TvDetailState.initial() => const TvDetailState(
        status: TvDetailStatus.initial,
        detail: null,
        recommendations: [],
        isInWatchlist: false,
        message: '',
      );

  TvDetailState copyWith({
    TvDetailStatus? status,
    TvDetail? detail,
    List<Tv>? recommendations,
    bool? isInWatchlist,
    String? message,
  }) =>
      TvDetailState(
        status: status ?? this.status,
        detail: detail ?? this.detail,
        recommendations: recommendations ?? this.recommendations,
        isInWatchlist: isInWatchlist ?? this.isInWatchlist,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props =>
      [status, detail, recommendations, isInWatchlist, message];
}
