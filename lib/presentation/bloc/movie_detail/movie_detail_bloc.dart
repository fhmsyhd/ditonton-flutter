import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<MovieDetailRequested>(_onDetailRequested);
    on<MovieWatchlistStatusRequested>(_onWatchlistStatusRequested);
    on<MovieWatchlistAdded>(_onWatchlistAdded);
    on<MovieWatchlistRemoved>(_onWatchlistRemoved);
  }

  Future<void> _onDetailRequested(
    MovieDetailRequested event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        detailStatus: MovieDetailStatus.loading,
        recommendationStatus: MovieRecommendationStatus.initial,
      ),
    );

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );

    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            detailStatus: MovieDetailStatus.error,
            detailMessage: failure.message,
          ),
        );
      },
      (movie) async {
        emit(
          state.copyWith(
            detailStatus: MovieDetailStatus.loaded,
            movie: movie,
            recommendationStatus: MovieRecommendationStatus.loading,
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationStatus: MovieRecommendationStatus.error,
              recommendationMessage: failure.message,
            ),
          ),
          (movies) => emit(
            state.copyWith(
              recommendationStatus: MovieRecommendationStatus.loaded,
              recommendations: movies,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onWatchlistStatusRequested(
    MovieWatchlistStatusRequested event,
    Emitter<MovieDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: isAdded));
  }

  Future<void> _onWatchlistAdded(
    MovieWatchlistAdded event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        watchlistActionStatus: MovieWatchlistActionStatus.processing,
        watchlistMessage: '',
      ),
    );

    final result = await saveWatchlist.execute(event.movie);
    final isAdded = await getWatchListStatus.execute(event.movie.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: MovieWatchlistActionStatus.error,
          watchlistMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: MovieWatchlistActionStatus.success,
          watchlistMessage: message,
        ),
      ),
    );
  }

  Future<void> _onWatchlistRemoved(
    MovieWatchlistRemoved event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        watchlistActionStatus: MovieWatchlistActionStatus.processing,
        watchlistMessage: '',
      ),
    );

    final result = await removeWatchlist.execute(event.movie);
    final isAdded = await getWatchListStatus.execute(event.movie.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: MovieWatchlistActionStatus.error,
          watchlistMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: MovieWatchlistActionStatus.success,
          watchlistMessage: message,
        ),
      ),
    );
  }
}
