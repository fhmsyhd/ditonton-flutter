import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_movie_event.dart';
part 'home_movie_state.dart';

class HomeMovieBloc extends Bloc<HomeMovieEvent, HomeMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  HomeMovieBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const HomeMovieState()) {
    on<HomeMovieNowPlayingRequested>(_onNowPlayingRequested);
    on<HomeMoviePopularRequested>(_onPopularRequested);
    on<HomeMovieTopRatedRequested>(_onTopRatedRequested);
  }

  Future<void> _onNowPlayingRequested(
    HomeMovieNowPlayingRequested event,
    Emitter<HomeMovieState> emit,
  ) async {
    emit(state.copyWith(nowPlayingStatus: HomeMovieStatus.loading));

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          nowPlayingStatus: HomeMovieStatus.error,
          nowPlayingMessage: failure.message,
        ),
      ),
      (movies) => emit(
        state.copyWith(
          nowPlayingStatus: HomeMovieStatus.loaded,
          nowPlayingMovies: movies,
        ),
      ),
    );
  }

  Future<void> _onPopularRequested(
    HomeMoviePopularRequested event,
    Emitter<HomeMovieState> emit,
  ) async {
    emit(state.copyWith(popularStatus: HomeMovieStatus.loading));

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularStatus: HomeMovieStatus.error,
          popularMessage: failure.message,
        ),
      ),
      (movies) => emit(
        state.copyWith(
          popularStatus: HomeMovieStatus.loaded,
          popularMovies: movies,
        ),
      ),
    );
  }

  Future<void> _onTopRatedRequested(
    HomeMovieTopRatedRequested event,
    Emitter<HomeMovieState> emit,
  ) async {
    emit(state.copyWith(topRatedStatus: HomeMovieStatus.loading));

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedStatus: HomeMovieStatus.error,
          topRatedMessage: failure.message,
        ),
      ),
      (movies) => emit(
        state.copyWith(
          topRatedStatus: HomeMovieStatus.loaded,
          topRatedMovies: movies,
        ),
      ),
    );
  }
}
