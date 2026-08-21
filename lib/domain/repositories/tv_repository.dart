import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class TvRepository {
  Future<Either<Failure, List<TV>>> getOnTheAirTv();
  Future<Either<Failure, List<TV>>> getPopularTv();
  Future<Either<Failure, List<TV>>> getTopRatedTv();
  Future<Either<Failure, TVDetail>> getTvDetail(int id);
  Future<Either<Failure, List<TV>>> getTvRecommendations(int id);
  Future<Either<Failure, List<TV>>> searchTv(String query);
  Future<Either<Failure, String>> saveWatchlist(TVDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TVDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TV>>> getWatchlistTv();
}
