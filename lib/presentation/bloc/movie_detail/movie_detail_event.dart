part of 'movie_detail_bloc.dart';

sealed class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

final class MovieDetailRequested extends MovieDetailEvent {
  final int id;

  const MovieDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}

final class MovieWatchlistStatusRequested extends MovieDetailEvent {
  final int id;

  const MovieWatchlistStatusRequested(this.id);

  @override
  List<Object?> get props => [id];
}

final class MovieWatchlistAdded extends MovieDetailEvent {
  final MovieDetail movie;

  const MovieWatchlistAdded(this.movie);

  @override
  List<Object?> get props => [movie];
}

final class MovieWatchlistRemoved extends MovieDetailEvent {
  final MovieDetail movie;

  const MovieWatchlistRemoved(this.movie);

  @override
  List<Object?> get props => [movie];
}
