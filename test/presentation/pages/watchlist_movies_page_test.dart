import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockWatchlistMovieBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const WatchlistMovieRequested());
    registerFallbackValue(const WatchlistMovieInitial());
  });

  setUp(() {
    mockBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget() => BlocProvider<WatchlistMovieBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: WatchlistMoviesPage()),
  );

  testWidgets('shows progress indicator when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistMovieLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows movie list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistMovieLoaded([]));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows message when request fails', (tester) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const WatchlistMovieError("Can't get data"));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text("Can't get data"), findsOneWidget);
  });
}
