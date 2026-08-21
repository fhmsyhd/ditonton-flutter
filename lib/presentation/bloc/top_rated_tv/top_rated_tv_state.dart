part of 'top_rated_tv_bloc.dart';

sealed class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object?> get props => [];
}

final class TopRatedTvInitial extends TopRatedTvState {
  const TopRatedTvInitial();
}

final class TopRatedTvLoading extends TopRatedTvState {
  const TopRatedTvLoading();
}

final class TopRatedTvLoaded extends TopRatedTvState {
  final List<TV> tvSeries;

  const TopRatedTvLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

final class TopRatedTvError extends TopRatedTvState {
  final String message;

  const TopRatedTvError(this.message);

  @override
  List<Object?> get props => [message];
}
