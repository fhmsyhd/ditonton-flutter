part of 'watchlist_tv_bloc.dart';

sealed class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object?> get props => [];
}

final class WatchlistTvRequested extends WatchlistTvEvent {
  const WatchlistTvRequested();
}
