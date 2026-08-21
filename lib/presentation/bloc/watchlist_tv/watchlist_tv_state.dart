part of 'watchlist_tv_bloc.dart';

sealed class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object?> get props => [];
}

final class WatchlistTvInitial extends WatchlistTvState {
  const WatchlistTvInitial();
}

final class WatchlistTvLoading extends WatchlistTvState {
  const WatchlistTvLoading();
}

final class WatchlistTvLoaded extends WatchlistTvState {
  final List<TV> tvSeries;

  const WatchlistTvLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

final class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object?> get props => [message];
}
