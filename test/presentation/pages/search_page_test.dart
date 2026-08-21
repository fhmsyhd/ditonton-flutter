import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

void main() {
  late MockMovieSearchBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const MovieSearchSubmitted(''));
    registerFallbackValue(const MovieSearchInitial());
  });

  setUp(() {
    mockBloc = MockMovieSearchBloc();
  });

  Widget makeTestableWidget() => BlocProvider<MovieSearchBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: SearchPage()),
  );

  testWidgets('submits query to BLoC', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchInitial());

    await tester.pumpWidget(makeTestableWidget());
    await tester.enterText(find.byType(TextField), 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(
      () => mockBloc.add(const MovieSearchSubmitted('spiderman')),
    ).called(1);
  });

  testWidgets('shows progress indicator when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows result list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchLoaded([]));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(ListView), findsOneWidget);
  });
}
