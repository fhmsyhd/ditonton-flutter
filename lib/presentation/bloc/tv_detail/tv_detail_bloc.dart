import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvDetailState()) {
    on<TvDetailRequested>(_onDetailRequested);
    on<TvWatchlistStatusRequested>(_onWatchlistStatusRequested);
    on<TvWatchlistAdded>(_onWatchlistAdded);
    on<TvWatchlistRemoved>(_onWatchlistRemoved);
  }

  Future<void> _onDetailRequested(
    TvDetailRequested event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        detailStatus: TvDetailStatus.loading,
        recommendationStatus: TvRecommendationStatus.initial,
      ),
    );

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);

    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            detailStatus: TvDetailStatus.error,
            detailMessage: failure.message,
          ),
        );
      },
      (tv) async {
        emit(
          state.copyWith(
            detailStatus: TvDetailStatus.loaded,
            tv: tv,
            recommendationStatus: TvRecommendationStatus.loading,
          ),
        );
        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationStatus: TvRecommendationStatus.error,
              recommendationMessage: failure.message,
            ),
          ),
          (tvSeries) => emit(
            state.copyWith(
              recommendationStatus: TvRecommendationStatus.loaded,
              recommendations: tvSeries,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onWatchlistStatusRequested(
    TvWatchlistStatusRequested event,
    Emitter<TvDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: isAdded));
  }

  Future<void> _onWatchlistAdded(
    TvWatchlistAdded event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        watchlistActionStatus: TvWatchlistActionStatus.processing,
        watchlistMessage: '',
      ),
    );
    final result = await saveWatchlist.execute(event.tv);
    final isAdded = await getWatchListStatus.execute(event.tv.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: TvWatchlistActionStatus.error,
          watchlistMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: TvWatchlistActionStatus.success,
          watchlistMessage: message,
        ),
      ),
    );
  }

  Future<void> _onWatchlistRemoved(
    TvWatchlistRemoved event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        watchlistActionStatus: TvWatchlistActionStatus.processing,
        watchlistMessage: '',
      ),
    );
    final result = await removeWatchlist.execute(event.tv);
    final isAdded = await getWatchListStatus.execute(event.tv.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: TvWatchlistActionStatus.error,
          watchlistMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistActionStatus: TvWatchlistActionStatus.success,
          watchlistMessage: message,
        ),
      ),
    );
  }
}
