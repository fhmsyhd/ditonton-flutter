import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWatchlistTv extends Mock implements GetWatchlistTv {}

void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;

  const tv = TV.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  const tvSeries = [tv];

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
  });

  test('initial state should be WatchlistTvInitial', () async {
    final bloc = WatchlistTvBloc(mockGetWatchlistTv);
    expect(bloc.state, const WatchlistTvInitial());
    await bloc.close();
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'emits loading and loaded when request succeeds',
    setUp: () => when(
      () => mockGetWatchlistTv.execute(),
    ).thenAnswer((_) async => const Right(tvSeries)),
    build: () => WatchlistTvBloc(mockGetWatchlistTv),
    act: (bloc) => bloc.add(const WatchlistTvRequested()),
    expect: () => const [WatchlistTvLoading(), WatchlistTvLoaded(tvSeries)],
    verify: (_) {
      verify(() => mockGetWatchlistTv.execute()).called(1);
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'emits loading and error when request fails',
    setUp: () => when(
      () => mockGetWatchlistTv.execute(),
    ).thenAnswer((_) async => const Left(DatabaseFailure("Can't get data"))),
    build: () => WatchlistTvBloc(mockGetWatchlistTv),
    act: (bloc) => bloc.add(const WatchlistTvRequested()),
    expect: () => const [
      WatchlistTvLoading(),
      WatchlistTvError("Can't get data"),
    ],
  );
}
