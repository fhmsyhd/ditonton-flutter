import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const id = 1;
  const recommendation = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 2,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  const recommendations = [recommendation];

  MovieDetailBloc buildBloc() => MovieDetailBloc(
    getMovieDetail: mockGetMovieDetail,
    getMovieRecommendations: mockGetMovieRecommendations,
    getWatchListStatus: mockGetWatchListStatus,
    saveWatchlist: mockSaveWatchlist,
    removeWatchlist: mockRemoveWatchlist,
  );

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
  });

  test('initial state should be empty', () async {
    final bloc = buildBloc();
    expect(bloc.state, const MovieDetailState());
    await bloc.close();
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits loaded detail and recommendations when request succeeds',
    setUp: () {
      when(
        () => mockGetMovieDetail.execute(id),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(
        () => mockGetMovieRecommendations.execute(id),
      ).thenAnswer((_) async => const Right(recommendations));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const MovieDetailRequested(id)),
    expect: () => [
      const MovieDetailState(detailStatus: MovieDetailStatus.loading),
      MovieDetailState(
        detailStatus: MovieDetailStatus.loaded,
        movie: testMovieDetail,
        recommendationStatus: MovieRecommendationStatus.loading,
      ),
      MovieDetailState(
        detailStatus: MovieDetailStatus.loaded,
        movie: testMovieDetail,
        recommendationStatus: MovieRecommendationStatus.loaded,
        recommendations: recommendations,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits error when detail request fails',
    setUp: () {
      when(
        () => mockGetMovieDetail.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(
        () => mockGetMovieRecommendations.execute(id),
      ).thenAnswer((_) async => const Right(recommendations));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const MovieDetailRequested(id)),
    expect: () => const [
      MovieDetailState(detailStatus: MovieDetailStatus.loading),
      MovieDetailState(
        detailStatus: MovieDetailStatus.error,
        detailMessage: 'Server Failure',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'keeps detail loaded and emits recommendation error',
    setUp: () {
      when(
        () => mockGetMovieDetail.execute(id),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(
        () => mockGetMovieRecommendations.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const MovieDetailRequested(id)),
    expect: () => [
      const MovieDetailState(detailStatus: MovieDetailStatus.loading),
      MovieDetailState(
        detailStatus: MovieDetailStatus.loaded,
        movie: testMovieDetail,
        recommendationStatus: MovieRecommendationStatus.loading,
      ),
      MovieDetailState(
        detailStatus: MovieDetailStatus.loaded,
        movie: testMovieDetail,
        recommendationStatus: MovieRecommendationStatus.error,
        recommendationMessage: 'Failed',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'updates watchlist status',
    setUp: () => when(
      () => mockGetWatchListStatus.execute(id),
    ).thenAnswer((_) async => true),
    build: buildBloc,
    act: (bloc) => bloc.add(const MovieWatchlistStatusRequested(id)),
    expect: () => const [MovieDetailState(isAddedToWatchlist: true)],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits success after adding movie to watchlist',
    setUp: () {
      when(
        () => mockSaveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        () => mockGetWatchListStatus.execute(id),
      ).thenAnswer((_) async => true);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(MovieWatchlistAdded(testMovieDetail)),
    expect: () => const [
      MovieDetailState(
        watchlistActionStatus: MovieWatchlistActionStatus.processing,
      ),
      MovieDetailState(
        isAddedToWatchlist: true,
        watchlistActionStatus: MovieWatchlistActionStatus.success,
        watchlistMessage: 'Added to Watchlist',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits error when adding movie to watchlist fails',
    setUp: () {
      when(
        () => mockSaveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(
        () => mockGetWatchListStatus.execute(id),
      ).thenAnswer((_) async => false);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(MovieWatchlistAdded(testMovieDetail)),
    expect: () => const [
      MovieDetailState(
        watchlistActionStatus: MovieWatchlistActionStatus.processing,
      ),
      MovieDetailState(
        watchlistActionStatus: MovieWatchlistActionStatus.error,
        watchlistMessage: 'Failed',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits success after removing movie from watchlist',
    setUp: () {
      when(
        () => mockRemoveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(
        () => mockGetWatchListStatus.execute(id),
      ).thenAnswer((_) async => false);
    },
    build: buildBloc,
    seed: () => const MovieDetailState(isAddedToWatchlist: true),
    act: (bloc) => bloc.add(MovieWatchlistRemoved(testMovieDetail)),
    expect: () => const [
      MovieDetailState(
        isAddedToWatchlist: true,
        watchlistActionStatus: MovieWatchlistActionStatus.processing,
      ),
      MovieDetailState(
        watchlistActionStatus: MovieWatchlistActionStatus.success,
        watchlistMessage: 'Removed from Watchlist',
      ),
    ],
  );
}
