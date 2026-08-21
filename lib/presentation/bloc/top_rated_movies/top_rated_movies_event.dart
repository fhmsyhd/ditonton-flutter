part of 'top_rated_movies_bloc.dart';

sealed class TopRatedMoviesEvent extends Equatable {
  const TopRatedMoviesEvent();

  @override
  List<Object?> get props => [];
}

final class TopRatedMoviesRequested extends TopRatedMoviesEvent {
  const TopRatedMoviesRequested();
}
