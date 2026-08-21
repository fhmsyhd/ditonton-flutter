import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _onTheAirTv = <TV>[];
  List<TV> get onTheAirTv => _onTheAirTv;

  RequestState _onTheAirState = RequestState.empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTv = <TV>[];
  List<TV> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.empty;
  RequestState get popularTvState => _popularTvState;

  var _topRatedTv = <TV>[];
  List<TV> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.empty;
  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getOnTheAirTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  });

  final GetOnTheAirTv getOnTheAirTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchOnTheAirTv() async {
    _onTheAirState = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTv.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _onTheAirState = RequestState.loaded;
        _onTheAirTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        _popularTvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTvState = RequestState.loaded;
        _popularTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedTvState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTvState = RequestState.loaded;
        _topRatedTv = tvData;
        notifyListeners();
      },
    );
  }
}
