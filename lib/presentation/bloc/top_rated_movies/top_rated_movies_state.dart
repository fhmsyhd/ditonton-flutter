part of 'top_rated_movies_bloc.dart';

sealed class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object?> get props => [];
}

final class TopRatedMoviesInitial extends TopRatedMoviesState {
  const TopRatedMoviesInitial();
}

final class TopRatedMoviesLoading extends TopRatedMoviesState {
  const TopRatedMoviesLoading();
}

final class TopRatedMoviesLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  const TopRatedMoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

final class TopRatedMoviesError extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
