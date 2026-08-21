import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_tv_event.dart';
part 'home_tv_state.dart';

class HomeTvBloc extends Bloc<HomeTvEvent, HomeTvState> {
  final GetOnTheAirTv getOnTheAirTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  HomeTvBloc({
    required this.getOnTheAirTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  }) : super(const HomeTvState()) {
    on<HomeTvOnTheAirRequested>(_onTheAirRequested);
    on<HomeTvPopularRequested>(_onPopularRequested);
    on<HomeTvTopRatedRequested>(_onTopRatedRequested);
  }

  Future<void> _onTheAirRequested(
    HomeTvOnTheAirRequested event,
    Emitter<HomeTvState> emit,
  ) async {
    emit(state.copyWith(onTheAirStatus: HomeTvStatus.loading));

    final result = await getOnTheAirTv.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          onTheAirStatus: HomeTvStatus.error,
          onTheAirMessage: failure.message,
        ),
      ),
      (tvSeries) => emit(
        state.copyWith(
          onTheAirStatus: HomeTvStatus.loaded,
          onTheAirTv: tvSeries,
        ),
      ),
    );
  }

  Future<void> _onPopularRequested(
    HomeTvPopularRequested event,
    Emitter<HomeTvState> emit,
  ) async {
    emit(state.copyWith(popularStatus: HomeTvStatus.loading));

    final result = await getPopularTv.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularStatus: HomeTvStatus.error,
          popularMessage: failure.message,
        ),
      ),
      (tvSeries) => emit(
        state.copyWith(popularStatus: HomeTvStatus.loaded, popularTv: tvSeries),
      ),
    );
  }

  Future<void> _onTopRatedRequested(
    HomeTvTopRatedRequested event,
    Emitter<HomeTvState> emit,
  ) async {
    emit(state.copyWith(topRatedStatus: HomeTvStatus.loading));

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedStatus: HomeTvStatus.error,
          topRatedMessage: failure.message,
        ),
      ),
      (tvSeries) => emit(
        state.copyWith(
          topRatedStatus: HomeTvStatus.loaded,
          topRatedTv: tvSeries,
        ),
      ),
    );
  }
}
