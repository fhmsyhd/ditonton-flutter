import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects_tv.dart';

class MockGetTvDetail extends Mock implements GetTvDetail {}

class MockGetTvRecommendations extends Mock implements GetTvRecommendations {}

class MockGetWatchListStatusTv extends Mock implements GetWatchListStatusTv {}

class MockSaveWatchlistTv extends Mock implements SaveWatchlistTv {}

class MockRemoveWatchlistTv extends Mock implements RemoveWatchlistTv {}

void main() {
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;

  const id = 1;
  const recommendation = TV(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 2,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  const recommendations = [recommendation];

  TvDetailBloc buildBloc() => TvDetailBloc(
    getTvDetail: mockGetTvDetail,
    getTvRecommendations: mockGetTvRecommendations,
    getWatchListStatus: mockGetWatchListStatus,
    saveWatchlist: mockSaveWatchlist,
    removeWatchlist: mockRemoveWatchlist,
  );

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
  });

  test('initial state should be empty', () async {
    final bloc = buildBloc();
    expect(bloc.state, const TvDetailState());
    await bloc.close();
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'emits loaded detail and recommendations when request succeeds',
    setUp: () {
      when(
        () => mockGetTvDetail.execute(id),
      ).thenAnswer((_) async => Right(testTvDetail));
      when(
        () => mockGetTvRecommendations.execute(id),
      ).thenAnswer((_) async => const Right(recommendations));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const TvDetailRequested(id)),
    expect: () => [
      const TvDetailState(detailStatus: TvDetailStatus.loading),
      TvDetailState(
        detailStatus: TvDetailStatus.loaded,
        tv: testTvDetail,
        recommendationStatus: TvRecommendationStatus.loading,
      ),
      TvDetailState(
        detailStatus: TvDetailStatus.loaded,
        tv: testTvDetail,
        recommendationStatus: TvRecommendationStatus.loaded,
        recommendations: recommendations,
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits error when detail request fails',
    setUp: () {
      when(
        () => mockGetTvDetail.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(
        () => mockGetTvRecommendations.execute(id),
      ).thenAnswer((_) async => const Right(recommendations));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const TvDetailRequested(id)),
    expect: () => const [
      TvDetailState(detailStatus: TvDetailStatus.loading),
      TvDetailState(
        detailStatus: TvDetailStatus.error,
        detailMessage: 'Server Failure',
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'keeps detail loaded and emits recommendation error',
    setUp: () {
      when(
        () => mockGetTvDetail.execute(id),
      ).thenAnswer((_) async => Right(testTvDetail));
      when(
        () => mockGetTvRecommendations.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const TvDetailRequested(id)),
    expect: () => [
      const TvDetailState(detailStatus: TvDetailStatus.loading),
      TvDetailState(
        detailStatus: TvDetailStatus.loaded,
        tv: testTvDetail,
        recommendationStatus: TvRecommendationStatus.loading,
      ),
      TvDetailState(
        detailStatus: TvDetailStatus.loaded,
        tv: testTvDetail,
        recommendationStatus: TvRecommendationStatus.error,
        recommendationMessage: 'Failed',
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'updates watchlist status',
    setUp: () => when(
      () => mockGetWatchListStatus.execute(id),
    ).thenAnswer((_) async => true),
    build: buildBloc,
    act: (bloc) => bloc.add(const TvWatchlistStatusRequested(id)),
    expect: () => const [TvDetailState(isAddedToWatchlist: true)],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits success after adding TV to watchlist',
    setUp: () {
      when(
        () => mockSaveWatchlist.execute(testTvDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        () => mockGetWatchListStatus.execute(id),
      ).thenAnswer((_) async => true);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(TvWatchlistAdded(testTvDetail)),
    expect: () => const [
      TvDetailState(watchlistActionStatus: TvWatchlistActionStatus.processing),
      TvDetailState(
        isAddedToWatchlist: true,
        watchlistActionStatus: TvWatchlistActionStatus.success,
        watchlistMessage: 'Added to Watchlist',
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits error when adding TV to watchlist fails',
    setUp: () {
      when(
        () => mockSaveWatchlist.execute(testTvDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(
        () => mockGetWatchListStatus.execute(id),
      ).thenAnswer((_) async => false);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(TvWatchlistAdded(testTvDetail)),
    expect: () => const [
      TvDetailState(watchlistActionStatus: TvWatchlistActionStatus.processing),
      TvDetailState(
        watchlistActionStatus: TvWatchlistActionStatus.error,
        watchlistMessage: 'Failed',
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits success after removing TV from watchlist',
    setUp: () {
      when(
        () => mockRemoveWatchlist.execute(testTvDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(
        () => mockGetWatchListStatus.execute(id),
      ).thenAnswer((_) async => false);
    },
    build: buildBloc,
    seed: () => const TvDetailState(isAddedToWatchlist: true),
    act: (bloc) => bloc.add(TvWatchlistRemoved(testTvDetail)),
    expect: () => const [
      TvDetailState(
        isAddedToWatchlist: true,
        watchlistActionStatus: TvWatchlistActionStatus.processing,
      ),
      TvDetailState(
        watchlistActionStatus: TvWatchlistActionStatus.success,
        watchlistMessage: 'Removed from Watchlist',
      ),
    ],
  );
}
