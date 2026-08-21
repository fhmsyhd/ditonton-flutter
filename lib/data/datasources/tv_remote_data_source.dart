import 'dart:convert';

import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnTheAirTv();
  Future<List<TvModel>> getPopularTv();
  Future<List<TvModel>> getTopRatedTv();
  Future<TVDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTv(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;
  final String apiKey;

  TvRemoteDataSourceImpl({required this.client, required this.apiKey});

  Uri _buildUri(String path, [Map<String, String> queryParameters = const {}]) {
    return Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: {'api_key': apiKey, ...queryParameters});
  }

  @override
  Future<List<TvModel>> getOnTheAirTv() async {
    final response = await client.get(_buildUri('/tv/on_the_air'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVDetailResponse> getTvDetail(int id) async {
    final response = await client.get(_buildUri('/tv/$id'));

    if (response.statusCode == 200) {
      return TVDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response = await client.get(_buildUri('/tv/$id/recommendations'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTv() async {
    final response = await client.get(_buildUri('/tv/popular'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTv() async {
    final response = await client.get(_buildUri('/tv/top_rated'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTv(String query) async {
    final response = await client.get(
      _buildUri('/search/tv', {'query': query}),
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
