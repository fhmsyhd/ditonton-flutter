import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/home_movie/home_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  const movie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  const movies = [movie];

  HomeMovieBloc buildBloc() => HomeMovieBloc(
    getNowPlayingMovies: mockGetNowPlayingMovies,
    getPopularMovies: mockGetPopularMovies,
    getTopRatedMovies: mockGetTopRatedMovies,
  );

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
  });

  test('initial state should be empty', () async {
    final bloc = buildBloc();

    expect(bloc.state, const HomeMovieState());

    await bloc.close();
  });

  blocTest<HomeMovieBloc, HomeMovieState>(
    'emits loading and loaded for now playing movies',
    setUp: () => when(
      () => mockGetNowPlayingMovies.execute(),
    ).thenAnswer((_) async => const Right(movies)),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeMovieNowPlayingRequested()),
    expect: () => const [
      HomeMovieState(nowPlayingStatus: HomeMovieStatus.loading),
      HomeMovieState(
        nowPlayingStatus: HomeMovieStatus.loaded,
        nowPlayingMovies: movies,
      ),
    ],
  );

  blocTest<HomeMovieBloc, HomeMovieState>(
    'emits loading and error for now playing movies',
    setUp: () => when(
      () => mockGetNowPlayingMovies.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeMovieNowPlayingRequested()),
    expect: () => const [
      HomeMovieState(nowPlayingStatus: HomeMovieStatus.loading),
      HomeMovieState(
        nowPlayingStatus: HomeMovieStatus.error,
        nowPlayingMessage: 'Server Failure',
      ),
    ],
  );

  blocTest<HomeMovieBloc, HomeMovieState>(
    'emits loading and loaded for popular movies',
    setUp: () => when(
      () => mockGetPopularMovies.execute(),
    ).thenAnswer((_) async => const Right(movies)),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeMoviePopularRequested()),
    expect: () => const [
      HomeMovieState(popularStatus: HomeMovieStatus.loading),
      HomeMovieState(
        popularStatus: HomeMovieStatus.loaded,
        popularMovies: movies,
      ),
    ],
  );

  blocTest<HomeMovieBloc, HomeMovieState>(
    'emits loading and error for popular movies',
    setUp: () => when(
      () => mockGetPopularMovies.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeMoviePopularRequested()),
    expect: () => const [
      HomeMovieState(popularStatus: HomeMovieStatus.loading),
      HomeMovieState(
        popularStatus: HomeMovieStatus.error,
        popularMessage: 'Server Failure',
      ),
    ],
  );

  blocTest<HomeMovieBloc, HomeMovieState>(
    'emits loading and loaded for top rated movies',
    setUp: () => when(
      () => mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => const Right(movies)),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeMovieTopRatedRequested()),
    expect: () => const [
      HomeMovieState(topRatedStatus: HomeMovieStatus.loading),
      HomeMovieState(
        topRatedStatus: HomeMovieStatus.loaded,
        topRatedMovies: movies,
      ),
    ],
  );

  blocTest<HomeMovieBloc, HomeMovieState>(
    'emits loading and error for top rated movies',
    setUp: () => when(
      () => mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeMovieTopRatedRequested()),
    expect: () => const [
      HomeMovieState(topRatedStatus: HomeMovieStatus.loading),
      HomeMovieState(
        topRatedStatus: HomeMovieStatus.error,
        topRatedMessage: 'Server Failure',
      ),
    ],
  );
}
