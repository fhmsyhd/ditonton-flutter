import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTopRatedTv extends Mock implements GetTopRatedTv {}

void main() {
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

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
  });

  test('initial state should be TopRatedTvInitial', () {
    final bloc = TopRatedTvBloc(mockGetTopRatedTv);

    expect(bloc.state, const TopRatedTvInitial());

    bloc.close();
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'emits loading and loaded when request succeeds',
    setUp: () {
      when(
        () => mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => const Right(tvSeries));
    },
    build: () => TopRatedTvBloc(mockGetTopRatedTv),
    act: (bloc) => bloc.add(const TopRatedTvRequested()),
    expect: () => const [TopRatedTvLoading(), TopRatedTvLoaded(tvSeries)],
    verify: (_) {
      verify(() => mockGetTopRatedTv.execute()).called(1);
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'emits loading and error when request fails',
    setUp: () {
      when(
        () => mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => TopRatedTvBloc(mockGetTopRatedTv),
    act: (bloc) => bloc.add(const TopRatedTvRequested()),
    expect: () => const [
      TopRatedTvLoading(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetTopRatedTv.execute()).called(1);
    },
  );
}
