import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TVDetailResponse extends Equatable {
  const TVDetailResponse({
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<SeasonModel> seasons;
  final String status;
  final String tagline;
  final double voteAverage;
  final int voteCount;

  factory TVDetailResponse.fromJson(Map<String, dynamic> json) {
    return TVDetailResponse(
      backdropPath: json["backdrop_path"],
      episodeRunTime: List<int>.from(
        (json["episode_run_time"] ?? []).map((x) => x),
      ),
      firstAirDate: json["first_air_date"] ?? '',
      genres: List<GenreModel>.from(
        (json["genres"] ?? []).map((x) => GenreModel.fromJson(x)),
      ),
      homepage: json["homepage"] ?? '',
      id: json["id"],
      name: json["name"] ?? '',
      numberOfEpisodes: json["number_of_episodes"] ?? 0,
      numberOfSeasons: json["number_of_seasons"] ?? 0,
      originalName: json["original_name"] ?? '',
      overview: json["overview"] ?? '',
      popularity: (json["popularity"] ?? 0).toDouble(),
      posterPath: json["poster_path"] ?? '',
      seasons: List<SeasonModel>.from(
        (json["seasons"] ?? []).map((x) => SeasonModel.fromJson(x)),
      ),
      status: json["status"] ?? '',
      tagline: json["tagline"] ?? '',
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      voteCount: json["vote_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
    "first_air_date": firstAirDate,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "name": name,
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasons,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
    "status": status,
    "tagline": tagline,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TVDetail toEntity() {
    return TVDetail(
      backdropPath: backdropPath,
      episodeRunTime: episodeRunTime,
      firstAirDate: firstAirDate,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      name: name,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      seasons: seasons.map((season) => season.toEntity()).toList(),
      status: status,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    episodeRunTime,
    firstAirDate,
    genres,
    homepage,
    id,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originalName,
    overview,
    popularity,
    posterPath,
    seasons,
    status,
    tagline,
    voteAverage,
    voteCount,
  ];
}
