part of 'home_movie_bloc.dart';

sealed class HomeMovieEvent extends Equatable {
  const HomeMovieEvent();

  @override
  List<Object?> get props => [];
}

final class HomeMovieNowPlayingRequested extends HomeMovieEvent {
  const HomeMovieNowPlayingRequested();
}

final class HomeMoviePopularRequested extends HomeMovieEvent {
  const HomeMoviePopularRequested();
}

final class HomeMovieTopRatedRequested extends HomeMovieEvent {
  const HomeMovieTopRatedRequested();
}
