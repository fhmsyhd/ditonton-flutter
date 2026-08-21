import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MockTvSearchBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const TvSearchSubmitted(''));
    registerFallbackValue(const TvSearchInitial());
  });

  setUp(() {
    mockBloc = MockTvSearchBloc();
  });

  Widget makeTestableWidget() => BlocProvider<TvSearchBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: SearchTvPage()),
  );

  testWidgets('submits query to BLoC', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSearchInitial());

    await tester.pumpWidget(makeTestableWidget());
    await tester.enterText(find.byKey(const Key('searchField')), 'Game');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(() => mockBloc.add(const TvSearchSubmitted('Game'))).called(1);
  });

  testWidgets('shows progress indicator when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSearchLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows result list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSearchLoaded([]));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(ListView), findsOneWidget);
  });
}
