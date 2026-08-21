part of 'home_movie_bloc.dart';

enum HomeMovieStatus { initial, loading, loaded, error }

final class HomeMovieState extends Equatable {
  final HomeMovieStatus nowPlayingStatus;
  final List<Movie> nowPlayingMovies;
  final String nowPlayingMessage;
  final HomeMovieStatus popularStatus;
  final List<Movie> popularMovies;
  final String popularMessage;
  final HomeMovieStatus topRatedStatus;
  final List<Movie> topRatedMovies;
  final String topRatedMessage;

  const HomeMovieState({
    this.nowPlayingStatus = HomeMovieStatus.initial,
    this.nowPlayingMovies = const [],
    this.nowPlayingMessage = '',
    this.popularStatus = HomeMovieStatus.initial,
    this.popularMovies = const [],
    this.popularMessage = '',
    this.topRatedStatus = HomeMovieStatus.initial,
    this.topRatedMovies = const [],
    this.topRatedMessage = '',
  });

  HomeMovieState copyWith({
    HomeMovieStatus? nowPlayingStatus,
    List<Movie>? nowPlayingMovies,
    String? nowPlayingMessage,
    HomeMovieStatus? popularStatus,
    List<Movie>? popularMovies,
    String? popularMessage,
    HomeMovieStatus? topRatedStatus,
    List<Movie>? topRatedMovies,
    String? topRatedMessage,
  }) {
    return HomeMovieState(
      nowPlayingStatus: nowPlayingStatus ?? this.nowPlayingStatus,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingMessage: nowPlayingMessage ?? this.nowPlayingMessage,
      popularStatus: popularStatus ?? this.popularStatus,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedStatus: topRatedStatus ?? this.topRatedStatus,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
    );
  }

  @override
  List<Object?> get props => [
    nowPlayingStatus,
    nowPlayingMovies,
    nowPlayingMessage,
    popularStatus,
    popularMovies,
    popularMessage,
    topRatedStatus,
    topRatedMovies,
    topRatedMessage,
  ];
}
