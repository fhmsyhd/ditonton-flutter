import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTv extends Mock implements SearchTv {}

void main() {
  late MockSearchTv mockSearchTv;

  const query = 'Game of Thrones';
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
    mockSearchTv = MockSearchTv();
  });

  test('initial state should be TvSearchInitial', () async {
    final bloc = TvSearchBloc(mockSearchTv);
    expect(bloc.state, const TvSearchInitial());
    await bloc.close();
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'emits loading and loaded when search succeeds',
    setUp: () => when(
      () => mockSearchTv.execute(query),
    ).thenAnswer((_) async => const Right(tvSeries)),
    build: () => TvSearchBloc(mockSearchTv),
    act: (bloc) => bloc.add(const TvSearchSubmitted(query)),
    expect: () => const [TvSearchLoading(), TvSearchLoaded(tvSeries)],
    verify: (_) {
      verify(() => mockSearchTv.execute(query)).called(1);
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'emits loading and error when search fails',
    setUp: () => when(
      () => mockSearchTv.execute(query),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: () => TvSearchBloc(mockSearchTv),
    act: (bloc) => bloc.add(const TvSearchSubmitted(query)),
    expect: () => const [TvSearchLoading(), TvSearchError('Server Failure')],
  );
}
