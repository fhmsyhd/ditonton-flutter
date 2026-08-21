part of 'home_tv_bloc.dart';

sealed class HomeTvEvent extends Equatable {
  const HomeTvEvent();

  @override
  List<Object?> get props => [];
}

final class HomeTvOnTheAirRequested extends HomeTvEvent {
  const HomeTvOnTheAirRequested();
}

final class HomeTvPopularRequested extends HomeTvEvent {
  const HomeTvPopularRequested();
}

final class HomeTvTopRatedRequested extends HomeTvEvent {
  const HomeTvTopRatedRequested();
}
