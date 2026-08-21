import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_the_air_tv_event.dart';
part 'on_the_air_tv_state.dart';

class OnTheAirTvBloc extends Bloc<OnTheAirTvEvent, OnTheAirTvState> {
  final GetOnTheAirTv getOnTheAirTv;

  OnTheAirTvBloc(this.getOnTheAirTv) : super(const OnTheAirTvInitial()) {
    on<OnTheAirTvRequested>(_onRequested);
  }

  Future<void> _onRequested(
    OnTheAirTvRequested event,
    Emitter<OnTheAirTvState> emit,
  ) async {
    emit(const OnTheAirTvLoading());

    final result = await getOnTheAirTv.execute();

    result.fold(
      (failure) => emit(OnTheAirTvError(failure.message)),
      (tvSeries) => emit(OnTheAirTvLoaded(tvSeries)),
    );
  }
}
