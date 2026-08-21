part of 'tv_detail_bloc.dart';

enum TvDetailStatus { initial, loading, loaded, error }

enum TvRecommendationStatus { initial, loading, loaded, error }

enum TvWatchlistActionStatus { idle, processing, success, error }

final class TvDetailState extends Equatable {
  final TvDetailStatus detailStatus;
  final TVDetail? tv;
  final String detailMessage;
  final TvRecommendationStatus recommendationStatus;
  final List<TV> recommendations;
  final String recommendationMessage;
  final bool isAddedToWatchlist;
  final TvWatchlistActionStatus watchlistActionStatus;
  final String watchlistMessage;

  const TvDetailState({
    this.detailStatus = TvDetailStatus.initial,
    this.tv,
    this.detailMessage = '',
    this.recommendationStatus = TvRecommendationStatus.initial,
    this.recommendations = const [],
    this.recommendationMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistActionStatus = TvWatchlistActionStatus.idle,
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    TvDetailStatus? detailStatus,
    TVDetail? tv,
    String? detailMessage,
    TvRecommendationStatus? recommendationStatus,
    List<TV>? recommendations,
    String? recommendationMessage,
    bool? isAddedToWatchlist,
    TvWatchlistActionStatus? watchlistActionStatus,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      detailStatus: detailStatus ?? this.detailStatus,
      tv: tv ?? this.tv,
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
    tv,
    detailMessage,
    recommendationStatus,
    recommendations,
    recommendationMessage,
    isAddedToWatchlist,
    watchlistActionStatus,
    watchlistMessage,
  ];
}
