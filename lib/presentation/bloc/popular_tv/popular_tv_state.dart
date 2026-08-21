part of 'popular_tv_bloc.dart';

sealed class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object?> get props => [];
}

final class PopularTvInitial extends PopularTvState {
  const PopularTvInitial();
}

final class PopularTvLoading extends PopularTvState {
  const PopularTvLoading();
}

final class PopularTvLoaded extends PopularTvState {
  final List<TV> tvSeries;

  const PopularTvLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

final class PopularTvError extends PopularTvState {
  final String message;

  const PopularTvError(this.message);

  @override
  List<Object?> get props => [message];
}
