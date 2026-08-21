import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv searchTv;

  TvSearchBloc(this.searchTv) : super(const TvSearchInitial()) {
    on<TvSearchSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    TvSearchSubmitted event,
    Emitter<TvSearchState> emit,
  ) async {
    emit(const TvSearchLoading());

    final result = await searchTv.execute(event.query);
    result.fold(
      (failure) => emit(TvSearchError(failure.message)),
      (tvSeries) => emit(TvSearchLoaded(tvSeries)),
    );
  }
}
