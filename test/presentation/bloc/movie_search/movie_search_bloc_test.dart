import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MockSearchMovies mockSearchMovies;

  const query = 'spiderman';
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
    mockSearchMovies = MockSearchMovies();
  });

  test('initial state should be MovieSearchInitial', () async {
    final bloc = MovieSearchBloc(mockSearchMovies);
    expect(bloc.state, const MovieSearchInitial());
    await bloc.close();
  });

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits loading and loaded when search succeeds',
    setUp: () => when(
      () => mockSearchMovies.execute(query),
    ).thenAnswer((_) async => const Right(movies)),
    build: () => MovieSearchBloc(mockSearchMovies),
    act: (bloc) => bloc.add(const MovieSearchSubmitted(query)),
    expect: () => const [MovieSearchLoading(), MovieSearchLoaded(movies)],
    verify: (_) {
      verify(() => mockSearchMovies.execute(query)).called(1);
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits loading and error when search fails',
    setUp: () => when(
      () => mockSearchMovies.execute(query),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    build: () => MovieSearchBloc(mockSearchMovies),
    act: (bloc) => bloc.add(const MovieSearchSubmitted(query)),
    expect: () => const [
      MovieSearchLoading(),
      MovieSearchError('Server Failure'),
    ],
  );
}
