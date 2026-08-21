import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    context.read<TvDetailBloc>()
      ..add(TvDetailRequested(widget.id))
      ..add(TvWatchlistStatusRequested(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvDetailBloc, TvDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistActionStatus != current.watchlistActionStatus &&
            (current.watchlistActionStatus == TvWatchlistActionStatus.success ||
                current.watchlistActionStatus == TvWatchlistActionStatus.error),
        listener: (context, state) {
          if (state.watchlistActionStatus == TvWatchlistActionStatus.success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.watchlistMessage)));
          } else {
            showDialog<void>(
              context: context,
              builder: (context) =>
                  AlertDialog(content: Text(state.watchlistMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state.detailStatus == TvDetailStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.detailStatus == TvDetailStatus.loaded) {
            return SafeArea(
              child: TvDetailContent(
                state.tv!,
                state.recommendations,
                state.isAddedToWatchlist,
                recommendationStatus: state.recommendationStatus,
                recommendationMessage: state.recommendationMessage,
              ),
            );
          } else {
            return Text(state.detailMessage);
          }
        },
      ),
    );
  }
}

class TvDetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;
  final TvRecommendationStatus recommendationStatus;
  final String recommendationMessage;

  const TvDetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist, {
    required this.recommendationStatus,
    required this.recommendationMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: richBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                              onPressed: () {
                                if (!isAddedWatchlist) {
                                  context.read<TvDetailBloc>().add(
                                    TvWatchlistAdded(tv),
                                  );
                                } else {
                                  context.read<TvDetailBloc>().add(
                                    TvWatchlistRemoved(tv),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tv.genres)),
                            Text(_showDuration(tv.episodeRunTime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: mikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(tv.overview),
                            SizedBox(height: 16),
                            Text('Seasons', style: heading6),
                            Text(
                              '${tv.numberOfSeasons} season(s) • ${tv.numberOfEpisodes} episode(s) • ${tv.status}',
                            ),
                            SizedBox(height: 8),
                            SeasonList(tv.seasons),
                            SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            _buildRecommendations(context),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
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
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    if (recommendationStatus == TvRecommendationStatus.loading) {
      return Center(child: CircularProgressIndicator());
    } else if (recommendationStatus == TvRecommendationStatus.error) {
      return Text(recommendationMessage);
    } else if (recommendationStatus == TvRecommendationStatus.loaded) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recommendation = recommendations[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    TvDetailPage.routeName,
                    arguments: recommendation.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: '$baseImageUrl${recommendation.posterPath}',
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
          itemCount: recommendations.length,
        ),
      );
    } else {
      return Container();
    }
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(List<int> episodeRunTime) {
    if (episodeRunTime.isEmpty) {
      return '';
    }
    final int minutes = episodeRunTime.first;
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m per episode';
    } else {
      return '${remainingMinutes}m per episode';
    }
  }
}

class SeasonList extends StatelessWidget {
  final List<Season> seasons;

  const SeasonList(this.seasons, {super.key});

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return Text('No season information available');
    }
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: season.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl: '$baseImageUrl${season.posterPath}',
                              height: 80,
                              width: 104,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Container(
                              height: 80,
                              width: 104,
                              color: grey,
                              child: Icon(Icons.tv),
                            ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      season.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subtitle,
                    ),
                    Text(
                      '${season.episodeCount ?? 0} episodes',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: seasons.length,
      ),
    );
  }
}
