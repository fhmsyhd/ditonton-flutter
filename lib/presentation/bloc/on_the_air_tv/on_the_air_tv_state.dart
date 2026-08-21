part of 'on_the_air_tv_bloc.dart';

sealed class OnTheAirTvState extends Equatable {
  const OnTheAirTvState();

  @override
  List<Object?> get props => [];
}

final class OnTheAirTvInitial extends OnTheAirTvState {
  const OnTheAirTvInitial();
}

final class OnTheAirTvLoading extends OnTheAirTvState {
  const OnTheAirTvLoading();
}

final class OnTheAirTvLoaded extends OnTheAirTvState {
  final List<TV> tvSeries;

  const OnTheAirTvLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

final class OnTheAirTvError extends OnTheAirTvState {
  final String message;

  const OnTheAirTvError(this.message);

  @override
  List<Object?> get props => [message];
}
