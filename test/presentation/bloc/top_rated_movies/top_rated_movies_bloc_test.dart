import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
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

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
  });

  test('initial state should be TopRatedMoviesInitial', () {
    final bloc = TopRatedMoviesBloc(mockGetTopRatedMovies);

    expect(bloc.state, const TopRatedMoviesInitial());

    bloc.close();
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'emits loading and loaded when request succeeds',
    setUp: () {
      when(
        () => mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => const Right(movies));
    },
    build: () => TopRatedMoviesBloc(mockGetTopRatedMovies),
    act: (bloc) => bloc.add(const TopRatedMoviesRequested()),
    expect: () => const [TopRatedMoviesLoading(), TopRatedMoviesLoaded(movies)],
    verify: (_) {
      verify(() => mockGetTopRatedMovies.execute()).called(1);
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'emits loading and error when request fails',
    setUp: () {
      when(
        () => mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => TopRatedMoviesBloc(mockGetTopRatedMovies),
    act: (bloc) => bloc.add(const TopRatedMoviesRequested()),
    expect: () => const [
      TopRatedMoviesLoading(),
      TopRatedMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetTopRatedMovies.execute()).called(1);
    },
  );
}
