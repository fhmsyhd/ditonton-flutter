import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlistTv;

  WatchlistTvBloc(this.getWatchlistTv) : super(const WatchlistTvInitial()) {
    on<WatchlistTvRequested>(_onRequested);
  }

  Future<void> _onRequested(
    WatchlistTvRequested event,
    Emitter<WatchlistTvState> emit,
  ) async {
    emit(const WatchlistTvLoading());

    final result = await getWatchlistTv.execute();
    result.fold(
      (failure) => emit(WatchlistTvError(failure.message)),
      (tvSeries) => emit(WatchlistTvLoaded(tvSeries)),
    );
  }
}
