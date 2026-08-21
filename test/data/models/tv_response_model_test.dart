import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: "/backdrop3.jpg",
    genreIds: [10759, 18],
    id: 66732,
    originalName: "Stranger Things",
    overview: "When a young boy vanishes, a small town uncovers a mystery.",
    popularity: 542.12,
    posterPath: "/poster3.jpg",
    firstAirDate: "2016-07-15",
    name: "Stranger Things",
    voteAverage: 8.6,
    voteCount: 15234,
  );

  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/search_stranger_things_tv.json'),
      );
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/backdrop3.jpg",
            "genre_ids": [10759, 18],
            "id": 66732,
            "original_name": "Stranger Things",
            "overview":
                "When a young boy vanishes, a small town uncovers a mystery.",
            "popularity": 542.12,
            "poster_path": "/poster3.jpg",
            "first_air_date": "2016-07-15",
            "name": "Stranger Things",
            "vote_average": 8.6,
            "vote_count": 15234,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
