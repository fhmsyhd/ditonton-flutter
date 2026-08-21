import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularTv extends Mock implements GetPopularTv {}

void main() {
  late MockGetPopularTv mockGetPopularTv;

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
    mockGetPopularTv = MockGetPopularTv();
  });

  test('initial state should be PopularTvInitial', () {
    final bloc = PopularTvBloc(mockGetPopularTv);

    expect(bloc.state, const PopularTvInitial());

    bloc.close();
  });

  blocTest<PopularTvBloc, PopularTvState>(
    'emits loading and loaded when request succeeds',
    setUp: () {
      when(
        () => mockGetPopularTv.execute(),
      ).thenAnswer((_) async => const Right(tvSeries));
    },
    build: () => PopularTvBloc(mockGetPopularTv),
    act: (bloc) => bloc.add(const PopularTvRequested()),
    expect: () => const [PopularTvLoading(), PopularTvLoaded(tvSeries)],
    verify: (_) {
      verify(() => mockGetPopularTv.execute()).called(1);
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'emits loading and error when request fails',
    setUp: () {
      when(
        () => mockGetPopularTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => PopularTvBloc(mockGetPopularTv),
    act: (bloc) => bloc.add(const PopularTvRequested()),
    expect: () => const [PopularTvLoading(), PopularTvError('Server Failure')],
    verify: (_) {
      verify(() => mockGetPopularTv.execute()).called(1);
    },
  );
}
