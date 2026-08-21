part of 'movie_search_bloc.dart';

sealed class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

final class MovieSearchSubmitted extends MovieSearchEvent {
  final String query;

  const MovieSearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}
