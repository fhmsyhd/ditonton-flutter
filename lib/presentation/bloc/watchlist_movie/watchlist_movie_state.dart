part of 'watchlist_movie_bloc.dart';

sealed class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object?> get props => [];
}

final class WatchlistMovieInitial extends WatchlistMovieState {
  const WatchlistMovieInitial();
}

final class WatchlistMovieLoading extends WatchlistMovieState {
  const WatchlistMovieLoading();
}

final class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> movies;

  const WatchlistMovieLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

final class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object?> get props => [message];
}
