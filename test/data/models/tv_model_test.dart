import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
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

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = {
      "backdrop_path": "backdropPath",
      "genre_ids": [1, 2, 3],
      "id": 1,
      "original_name": "originalName",
      "overview": "overview",
      "popularity": 1,
      "poster_path": "posterPath",
      "first_air_date": "firstAirDate",
      "name": "name",
      "vote_average": 1,
      "vote_count": 1,
    };
    // act
    final result = TvModel.fromJson(jsonMap);
    // assert
    expect(result, tTvModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTvModel.toJson();
    // assert
    final expectedJsonMap = {
      "backdrop_path": "backdropPath",
      "genre_ids": [1, 2, 3],
      "id": 1,
      "original_name": "originalName",
      "overview": "overview",
      "popularity": 1.0,
      "poster_path": "posterPath",
      "first_air_date": "firstAirDate",
      "name": "name",
      "vote_average": 1.0,
      "vote_count": 1,
    };
    expect(result, expectedJsonMap);
  });
}
