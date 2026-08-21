import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = TV(
    backdropPath: '/backdrop1.jpg',
    genreIds: [18, 10765],
    id: 1399,
    originalName: 'Game of Thrones',
    overview:
        'Seven noble families fight for control of the mythical land of Westeros.',
    popularity: 369.594,
    posterPath: '/poster1.jpg',
    firstAirDate: '2011-04-17',
    name: 'Game of Thrones',
    voteAverage: 8.4,
    voteCount: 11504,
  );
  final tTvList = <TV>[tTv];
  final tQuery = 'Game of Thrones';

  group('search tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.loading);
    });

    test(
      'should change search result data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchTv.execute(tQuery),
        ).thenAnswer((_) async => Right(tTvList));
        // act
        await provider.fetchTvSearch(tQuery);
        // assert
        expect(provider.state, RequestState.loaded);
        expect(provider.searchResult, tTvList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
