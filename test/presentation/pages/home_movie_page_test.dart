import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/home_movie/home_movie_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeMovieBloc extends MockBloc<HomeMovieEvent, HomeMovieState>
    implements HomeMovieBloc {}

void main() {
  late MockHomeMovieBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const HomeMovieNowPlayingRequested());
    registerFallbackValue(const HomeMovieState());
  });

  setUp(() {
    mockBloc = MockHomeMovieBloc();
  });

  Widget makeTestableWidget() => BlocProvider<HomeMovieBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: HomeMoviePage()),
  );

  testWidgets('shows progress indicators when sections are loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const HomeMovieState(
        nowPlayingStatus: HomeMovieStatus.loading,
        popularStatus: HomeMovieStatus.loading,
        topRatedStatus: HomeMovieStatus.loading,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('shows movie lists when sections are loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const HomeMovieState(
        nowPlayingStatus: HomeMovieStatus.loaded,
        popularStatus: HomeMovieStatus.loaded,
        topRatedStatus: HomeMovieStatus.loaded,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('shows failure messages when sections fail', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const HomeMovieState(
        nowPlayingStatus: HomeMovieStatus.error,
        popularStatus: HomeMovieStatus.error,
        topRatedStatus: HomeMovieStatus.error,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed'), findsNWidgets(3));
  });
}
