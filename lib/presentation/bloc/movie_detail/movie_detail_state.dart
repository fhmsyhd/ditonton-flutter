part of 'movie_detail_bloc.dart';

enum MovieDetailStatus { initial, loading, loaded, error }

enum MovieRecommendationStatus { initial, loading, loaded, error }

enum MovieWatchlistActionStatus { idle, processing, success, error }

final class MovieDetailState extends Equatable {
  final MovieDetailStatus detailStatus;
  final MovieDetail? movie;
  final String detailMessage;
  final MovieRecommendationStatus recommendationStatus;
  final List<Movie> recommendations;
  final String recommendationMessage;
  final bool isAddedToWatchlist;
  final MovieWatchlistActionStatus watchlistActionStatus;
  final String watchlistMessage;

  const MovieDetailState({
    this.detailStatus = MovieDetailStatus.initial,
    this.movie,
    this.detailMessage = '',
    this.recommendationStatus = MovieRecommendationStatus.initial,
    this.recommendations = const [],
    this.recommendationMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistActionStatus = MovieWatchlistActionStatus.idle,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    MovieDetailStatus? detailStatus,
    MovieDetail? movie,
    String? detailMessage,
    MovieRecommendationStatus? recommendationStatus,
    List<Movie>? recommendations,
    String? recommendationMessage,
    bool? isAddedToWatchlist,
    MovieWatchlistActionStatus? watchlistActionStatus,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      detailStatus: detailStatus ?? this.detailStatus,
      movie: movie ?? this.movie,
      detailMessage: detailMessage ?? this.detailMessage,
      recommendationStatus: recommendationStatus ?? this.recommendationStatus,
      recommendations: recommendations ?? this.recommendations,
      recommendationMessage:
          recommendationMessage ?? this.recommendationMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistActionStatus:
          watchlistActionStatus ?? this.watchlistActionStatus,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    detailStatus,
    movie,
    detailMessage,
    recommendationStatus,
    recommendations,
    recommendationMessage,
    isAddedToWatchlist,
    watchlistActionStatus,
    watchlistMessage,
  ];
}
