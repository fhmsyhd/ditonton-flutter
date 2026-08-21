import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testTv = TV(
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

final testTvList = [testTv];

final testSeason = Season(
  id: 3624,
  name: 'Season 1',
  overview: '',
  posterPath: '/season1.jpg',
  seasonNumber: 1,
  episodeCount: 10,
  airDate: '2011-04-17',
);

final testTvDetail = TVDetail(
  backdropPath: 'backdropPath',
  episodeRunTime: [55],
  firstAirDate: 'firstAirDate',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [testSeason],
  status: 'Ended',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTv = TV.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
