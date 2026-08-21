import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  const movie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  const movies = [movie];

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
  });

  test('initial state should be WatchlistMovieInitial', () async {
    final bloc = WatchlistMovieBloc(mockGetWatchlistMovies);
    expect(bloc.state, const WatchlistMovieInitial());
    await bloc.close();
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits loading and loaded when request succeeds',
    setUp: () => when(
      () => mockGetWatchlistMovies.execute(),
    ).thenAnswer((_) async => const Right(movies)),
    build: () => WatchlistMovieBloc(mockGetWatchlistMovies),
    act: (bloc) => bloc.add(const WatchlistMovieRequested()),
    expect: () => const [WatchlistMovieLoading(), WatchlistMovieLoaded(movies)],
    verify: (_) {
      verify(() => mockGetWatchlistMovies.execute()).called(1);
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits loading and error when request fails',
    setUp: () => when(
      () => mockGetWatchlistMovies.execute(),
    ).thenAnswer((_) async => const Left(DatabaseFailure("Can't get data"))),
    build: () => WatchlistMovieBloc(mockGetWatchlistMovies),
    act: (bloc) => bloc.add(const WatchlistMovieRequested()),
    expect: () => const [
      WatchlistMovieLoading(),
      WatchlistMovieError("Can't get data"),
    ],
  );
}
