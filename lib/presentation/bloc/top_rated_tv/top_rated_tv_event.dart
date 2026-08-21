part of 'top_rated_tv_bloc.dart';

sealed class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  List<Object?> get props => [];
}

final class TopRatedTvRequested extends TopRatedTvEvent {
  const TopRatedTvRequested();
}
