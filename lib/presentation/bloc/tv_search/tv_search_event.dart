part of 'tv_search_bloc.dart';

sealed class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object?> get props => [];
}

final class TvSearchSubmitted extends TvSearchEvent {
  final String query;

  const TvSearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}
