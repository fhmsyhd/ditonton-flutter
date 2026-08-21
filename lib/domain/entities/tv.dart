import 'package:equatable/equatable.dart';

class TV extends Equatable {
  const TV({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  const TV.watchlist({
    required int id,
    required String? overview,
    required String? posterPath,
    required String? name,
  }) : this(
         backdropPath: null,
         genreIds: null,
         id: id,
         originalName: null,
         overview: overview,
         popularity: null,
         posterPath: posterPath,
         firstAirDate: null,
         name: name,
         voteAverage: null,
         voteCount: null,
       );

  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? name;
  final double? voteAverage;
  final int? voteCount;

  @override
  List<Object?> get props => [
    backdropPath,
    genreIds,
    id,
    originalName,
    overview,
    popularity,
    posterPath,
    firstAirDate,
    name,
    voteAverage,
    voteCount,
  ];
}
