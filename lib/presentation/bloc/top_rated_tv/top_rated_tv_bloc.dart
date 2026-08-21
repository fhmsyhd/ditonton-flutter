import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv getTopRatedTv;

  TopRatedTvBloc(this.getTopRatedTv) : super(const TopRatedTvInitial()) {
    on<TopRatedTvRequested>(_onRequested);
  }

  Future<void> _onRequested(
    TopRatedTvRequested event,
    Emitter<TopRatedTvState> emit,
  ) async {
    emit(const TopRatedTvLoading());

    final result = await getTopRatedTv.execute();

    result.fold(
      (failure) => emit(TopRatedTvError(failure.message)),
      (tvSeries) => emit(TopRatedTvLoaded(tvSeries)),
    );
  }
}
