import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late MockGetPopularMovies mockGetPopularMovies;

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

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
  });

  test('initial state should be PopularMoviesInitial', () {
    final bloc = PopularMoviesBloc(mockGetPopularMovies);

    expect(bloc.state, const PopularMoviesInitial());

    bloc.close();
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'emits loading and loaded when request succeeds',
    setUp: () {
      when(
        () => mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => const Right(movies));
    },
    build: () => PopularMoviesBloc(mockGetPopularMovies),
    act: (bloc) => bloc.add(const PopularMoviesRequested()),
    expect: () => const [PopularMoviesLoading(), PopularMoviesLoaded(movies)],
    verify: (_) {
      verify(() => mockGetPopularMovies.execute()).called(1);
    },
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'emits loading and error when request fails',
    setUp: () {
      when(
        () => mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => PopularMoviesBloc(mockGetPopularMovies),
    act: (bloc) => bloc.add(const PopularMoviesRequested()),
    expect: () => const [
      PopularMoviesLoading(),
      PopularMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetPopularMovies.execute()).called(1);
    },
  );
}
