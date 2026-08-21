part of 'movie_search_bloc.dart';

sealed class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object?> get props => [];
}

final class MovieSearchInitial extends MovieSearchState {
  const MovieSearchInitial();
}

final class MovieSearchLoading extends MovieSearchState {
  const MovieSearchLoading();
}

final class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;

  const MovieSearchLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

final class MovieSearchError extends MovieSearchState {
  final String message;

  const MovieSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
