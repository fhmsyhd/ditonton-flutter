part of 'popular_tv_bloc.dart';

sealed class PopularTvEvent extends Equatable {
  const PopularTvEvent();

  @override
  List<Object?> get props => [];
}

final class PopularTvRequested extends PopularTvEvent {
  const PopularTvRequested();
}
