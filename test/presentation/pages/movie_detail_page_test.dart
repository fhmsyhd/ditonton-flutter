import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  MovieDetailState loadedState({
    bool isAdded = false,
    MovieWatchlistActionStatus actionStatus = MovieWatchlistActionStatus.idle,
    String actionMessage = '',
  }) => MovieDetailState(
    detailStatus: MovieDetailStatus.loaded,
    movie: testMovieDetail,
    recommendationStatus: MovieRecommendationStatus.loaded,
    isAddedToWatchlist: isAdded,
    watchlistActionStatus: actionStatus,
    watchlistMessage: actionMessage,
  );

  setUpAll(() {
    registerFallbackValue(const MovieDetailRequested(0));
    registerFallbackValue(const MovieDetailState());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget() => BlocProvider<MovieDetailBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: MovieDetailPage(id: 1)),
  );

  testWidgets('shows add icon when movie is not in watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('shows check icon when movie is in watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(loadedState(isAdded: true));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('dispatches add event when watchlist button is tapped', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(find.byType(FilledButton));

    verify(() => mockBloc.add(MovieWatchlistAdded(testMovieDetail))).called(1);
  });

  testWidgets('shows Snackbar after successful watchlist action', (
    tester,
  ) async {
    final initialState = loadedState();
    final successState = loadedState(
      isAdded: true,
      actionStatus: MovieWatchlistActionStatus.success,
      actionMessage: 'Added to Watchlist',
    );
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([successState]),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('shows AlertDialog after failed watchlist action', (
    tester,
  ) async {
    final initialState = loadedState();
    final errorState = loadedState(
      actionStatus: MovieWatchlistActionStatus.error,
      actionMessage: 'Failed',
    );
    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([errorState]),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
