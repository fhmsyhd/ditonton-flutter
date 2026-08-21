part of 'tv_detail_bloc.dart';

sealed class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object?> get props => [];
}

final class TvDetailRequested extends TvDetailEvent {
  final int id;
  const TvDetailRequested(this.id);
  @override
  List<Object?> get props => [id];
}

final class TvWatchlistStatusRequested extends TvDetailEvent {
  final int id;
  const TvWatchlistStatusRequested(this.id);
  @override
  List<Object?> get props => [id];
}

final class TvWatchlistAdded extends TvDetailEvent {
  final TVDetail tv;
  const TvWatchlistAdded(this.tv);
  @override
  List<Object?> get props => [tv];
}

final class TvWatchlistRemoved extends TvDetailEvent {
  final TVDetail tv;
  const TvWatchlistRemoved(this.tv);
  @override
  List<Object?> get props => [tv];
}
