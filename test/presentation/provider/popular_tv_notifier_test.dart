import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late PopularTvNotifier notifier;
  late MockGetPopularTv mockGetPopularTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    notifier = PopularTvNotifier(mockGetPopularTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = TV(
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
  final tTvList = <TV>[tTv];

  test('initialState should be Empty', () {
    expect(notifier.state, equals(RequestState.empty));
  });

  test('should change state to Loading when usecase is called', () {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.loading);
  });

  test('should change tv when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.tv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetPopularTv.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
