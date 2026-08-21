import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/home_tv/home_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOnTheAirTv extends Mock implements GetOnTheAirTv {}

class MockGetPopularTv extends Mock implements GetPopularTv {}

class MockGetTopRatedTv extends Mock implements GetTopRatedTv {}

void main() {
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;

  const tv = TV(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  const tvSeries = [tv];

  HomeTvBloc buildBloc() => HomeTvBloc(
    getOnTheAirTv: mockGetOnTheAirTv,
    getPopularTv: mockGetPopularTv,
    getTopRatedTv: mockGetTopRatedTv,
  );

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
  });

  test('initial state should be empty', () async {
    final bloc = buildBloc();
    expect(bloc.state, const HomeTvState());
    await bloc.close();
  });

  blocTest<HomeTvBloc, HomeTvState>(
    'emits loading and loaded for on the air TV',
    setUp: () => when(
      () => mockGetOnTheAirTv.execute(),
    ).thenAnswer((_) async => const Right(tvSeries)),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeTvOnTheAirRequested()),
    expect: () => const [
      HomeTvState(onTheAirStatus: HomeTvStatus.loading),
      HomeTvState(onTheAirStatus: HomeTvStatus.loaded, onTheAirTv: tvSeries),
    ],
  );

  blocTest<HomeTvBloc, HomeTvState>(
    'emits loading and error for on the air TV',
    setUp: () => when(
      () => mockGetOnTheAirTv.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeTvOnTheAirRequested()),
    expect: () => const [
      HomeTvState(onTheAirStatus: HomeTvStatus.loading),
      HomeTvState(
        onTheAirStatus: HomeTvStatus.error,
        onTheAirMessage: 'Server Failure',
      ),
    ],
  );

  blocTest<HomeTvBloc, HomeTvState>(
    'emits loading and loaded for popular TV',
    setUp: () => when(
      () => mockGetPopularTv.execute(),
    ).thenAnswer((_) async => const Right(tvSeries)),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeTvPopularRequested()),
    expect: () => const [
      HomeTvState(popularStatus: HomeTvStatus.loading),
      HomeTvState(popularStatus: HomeTvStatus.loaded, popularTv: tvSeries),
    ],
  );

  blocTest<HomeTvBloc, HomeTvState>(
    'emits loading and error for popular TV',
    setUp: () => when(
      () => mockGetPopularTv.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeTvPopularRequested()),
    expect: () => const [
      HomeTvState(popularStatus: HomeTvStatus.loading),
      HomeTvState(
        popularStatus: HomeTvStatus.error,
        popularMessage: 'Server Failure',
      ),
    ],
  );

  blocTest<HomeTvBloc, HomeTvState>(
    'emits loading and loaded for top rated TV',
    setUp: () => when(
      () => mockGetTopRatedTv.execute(),
    ).thenAnswer((_) async => const Right(tvSeries)),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeTvTopRatedRequested()),
    expect: () => const [
      HomeTvState(topRatedStatus: HomeTvStatus.loading),
      HomeTvState(topRatedStatus: HomeTvStatus.loaded, topRatedTv: tvSeries),
    ],
  );

  blocTest<HomeTvBloc, HomeTvState>(
    'emits loading and error for top rated TV',
    setUp: () => when(
      () => mockGetTopRatedTv.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeTvTopRatedRequested()),
    expect: () => const [
      HomeTvState(topRatedStatus: HomeTvStatus.loading),
      HomeTvState(
        topRatedStatus: HomeTvStatus.error,
        topRatedMessage: 'Server Failure',
      ),
    ],
  );
}
