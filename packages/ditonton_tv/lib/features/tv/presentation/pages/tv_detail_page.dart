// ignore_for_file: use_build_context_synchronously
import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/season_detail_cubit.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = '/tv-detail';

  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TvDetailBloc>().add(FetchTvDetailEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state.status == TvDetailStatus.loading) {
            return const DetailPageSkeleton();
          } else if (state.status == TvDetailStatus.loaded &&
              state.detail != null) {
            final tv = state.detail!;
            return SafeArea(
              child: _DetailContent(
                tv,
                state.recommendations,
                state.isInWatchlist,
              ),
            );
          } else if (state.status == TvDetailStatus.error) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  const _DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedImage(
          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
          width: screenWidth,
          height: 300,
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tv.name, style: heading5),
                            FilledButton(
                              onPressed: () async {
                                context
                                    .read<TvDetailBloc>()
                                    .add(ToggleWatchlistEvent());
                                final message =
                                    context.read<TvDetailBloc>().state.message;
                                if (message.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tv.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: mikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(tv.overview),
                            const SizedBox(height: 16),
                            // Seasons & Episodes
                            if (tv.seasons.isNotEmpty) ...[
                              Text('Seasons', style: heading6),
                              const SizedBox(height: 8),
                              _SeasonsList(seasons: tv.seasons, tvId: tv.id),
                            ],
                            const SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            Builder(builder: (context) {
                              return SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recommendations.length,
                                  itemBuilder: (context, index) {
                                    final rec = recommendations[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            TvDetailPage.routeName,
                                            arguments: rec.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          child: CachedImage(
                                            imageUrl:
                                                '$BASE_IMAGE_URL${rec.posterPath}',
                                            width: 100,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child:
                          Container(color: Colors.white, height: 4, width: 48),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: richBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    if (genres.isEmpty) return '';
    return genres.map((g) => g.name).join(', ');
  }
}

class _SeasonsList extends StatelessWidget {
  final List<Season> seasons;
  final int tvId;

  const _SeasonsList({required this.seasons, required this.tvId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seasons.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final s = seasons[index];
        return BlocProvider(
          create: (ctx) => SeasonDetailCubit(
            getSeasonDetail: GetIt.I<GetSeasonDetail>(),
            tvId: tvId,
          ),
          child: BlocBuilder<SeasonDetailCubit, SeasonDetailState>(
            builder: (context, seasonState) {
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    if (s.posterPath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedImage(
                          imageUrl: '$BASE_IMAGE_URL${s.posterPath}',
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: subtitle),
                          const SizedBox(height: 4),
                          Text('Episodes: ${s.episodeCount}', style: bodyText),
                        ],
                      ),
                    ),
                  ],
                ),
                onExpansionChanged: (expanded) {
                  if (expanded) {
                    context.read<SeasonDetailCubit>().fetch(s.seasonNumber);
                  }
                },
                children: () {
                  if (seasonState.loading) {
                    return const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    ];
                  } else if (seasonState.episodes.isEmpty) {
                    return const [SizedBox.shrink()];
                  } else {
                    return seasonState.episodes
                        .map(
                          (e) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: e.stillPath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedImage(
                                      imageUrl: '$BASE_IMAGE_URL${e.stillPath}',
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const SizedBox(width: 80),
                            title: Text('${e.episodeNumber}. ${e.name}',
                                style: subtitle),
                            subtitle: Text(
                              e.overview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList();
                  }
                }(),
              );
            },
          ),
        );
      },
    );
  }
}
