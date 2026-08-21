import 'dart:convert';

import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'test-api-key';
  const baseUrl = 'https://api.themoviedb.org/3';

  Uri buildUri(String path, [Map<String, String> queryParameters = const {}]) {
    return Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: {'api_key': apiKey, ...queryParameters});
  }

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient, apiKey: apiKey);
  });

  group('get On The Air Tv', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/on_the_air_tv.json')),
    ).tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(buildUri('/tv/on_the_air'))).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/on_the_air_tv.json'), 200),
        );
        // act
        final result = await dataSource.getOnTheAirTv();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/tv/on_the_air')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Tv', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
    ).tvList;

    test('should return list of tv when response is success (200)', () async {
      // arrange
      when(mockHttpClient.get(buildUri('/tv/popular'))).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/popular_tv.json'), 200),
      );
      // act
      final result = await dataSource.getPopularTv();
      // assert
      expect(result, tTvList);
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/tv/popular')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Tv', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv.json')),
    ).tvList;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(buildUri('/tv/top_rated'))).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/top_rated_tv.json'), 200),
      );
      // act
      final result = await dataSource.getTopRatedTv();
      // assert
      expect(result, tTvList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/tv/top_rated')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    final tId = 1399;
    final tTvDetail = TVDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(buildUri('/tv/$tId'))).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_detail.json'), 200),
      );
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, equals(tTvDetail));
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/tv/$tId')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;
    final tId = 1399;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/tv/$tId/recommendations')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvRecommendations(tId);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/tv/$tId/recommendations')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(
      json.decode(readJson('dummy_data/search_stranger_things_tv.json')),
    ).tvList;
    final tQuery = 'Stranger Things';

    test('should return list of tv when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(buildUri('/search/tv', {'query': tQuery})),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_stranger_things_tv.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchTv(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(buildUri('/search/tv', {'query': tQuery})),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTv(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
