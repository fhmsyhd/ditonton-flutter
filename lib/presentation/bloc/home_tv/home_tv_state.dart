part of 'home_tv_bloc.dart';

enum HomeTvStatus { initial, loading, loaded, error }

final class HomeTvState extends Equatable {
  final HomeTvStatus onTheAirStatus;
  final List<TV> onTheAirTv;
  final String onTheAirMessage;
  final HomeTvStatus popularStatus;
  final List<TV> popularTv;
  final String popularMessage;
  final HomeTvStatus topRatedStatus;
  final List<TV> topRatedTv;
  final String topRatedMessage;

  const HomeTvState({
    this.onTheAirStatus = HomeTvStatus.initial,
    this.onTheAirTv = const [],
    this.onTheAirMessage = '',
    this.popularStatus = HomeTvStatus.initial,
    this.popularTv = const [],
    this.popularMessage = '',
    this.topRatedStatus = HomeTvStatus.initial,
    this.topRatedTv = const [],
    this.topRatedMessage = '',
  });

  HomeTvState copyWith({
    HomeTvStatus? onTheAirStatus,
    List<TV>? onTheAirTv,
    String? onTheAirMessage,
    HomeTvStatus? popularStatus,
    List<TV>? popularTv,
    String? popularMessage,
    HomeTvStatus? topRatedStatus,
    List<TV>? topRatedTv,
    String? topRatedMessage,
  }) {
    return HomeTvState(
      onTheAirStatus: onTheAirStatus ?? this.onTheAirStatus,
      onTheAirTv: onTheAirTv ?? this.onTheAirTv,
      onTheAirMessage: onTheAirMessage ?? this.onTheAirMessage,
      popularStatus: popularStatus ?? this.popularStatus,
      popularTv: popularTv ?? this.popularTv,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedStatus: topRatedStatus ?? this.topRatedStatus,
      topRatedTv: topRatedTv ?? this.topRatedTv,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
    );
  }

  @override
  List<Object?> get props => [
    onTheAirStatus,
    onTheAirTv,
    onTheAirMessage,
    popularStatus,
    popularTv,
    popularMessage,
    topRatedStatus,
    topRatedTv,
    topRatedMessage,
  ];
}
