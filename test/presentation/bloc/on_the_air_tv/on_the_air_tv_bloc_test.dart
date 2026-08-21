import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOnTheAirTv extends Mock implements GetOnTheAirTv {}

void main() {
  late MockGetOnTheAirTv mockGetOnTheAirTv;

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

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
  });

  test('initial state should be OnTheAirTvInitial', () {
    final bloc = OnTheAirTvBloc(mockGetOnTheAirTv);

    expect(bloc.state, const OnTheAirTvInitial());

    bloc.close();
  });

  blocTest<OnTheAirTvBloc, OnTheAirTvState>(
    'emits loading and loaded when request succeeds',
    setUp: () {
      when(
        () => mockGetOnTheAirTv.execute(),
      ).thenAnswer((_) async => const Right(tvSeries));
    },
    build: () => OnTheAirTvBloc(mockGetOnTheAirTv),
    act: (bloc) => bloc.add(const OnTheAirTvRequested()),
    expect: () => const [OnTheAirTvLoading(), OnTheAirTvLoaded(tvSeries)],
    verify: (_) {
      verify(() => mockGetOnTheAirTv.execute()).called(1);
    },
  );

  blocTest<OnTheAirTvBloc, OnTheAirTvState>(
    'emits loading and error when request fails',
    setUp: () {
      when(
        () => mockGetOnTheAirTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => OnTheAirTvBloc(mockGetOnTheAirTv),
    act: (bloc) => bloc.add(const OnTheAirTvRequested()),
    expect: () => const [
      OnTheAirTvLoading(),
      OnTheAirTvError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetOnTheAirTv.execute()).called(1);
    },
  );
}
