part of 'tv_search_bloc.dart';

sealed class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object?> get props => [];
}

final class TvSearchInitial extends TvSearchState {
  const TvSearchInitial();
}

final class TvSearchLoading extends TvSearchState {
  const TvSearchLoading();
}

final class TvSearchLoaded extends TvSearchState {
  final List<TV> tvSeries;

  const TvSearchLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

final class TvSearchError extends TvSearchState {
  final String message;

  const TvSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
