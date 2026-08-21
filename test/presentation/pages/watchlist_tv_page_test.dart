import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

void main() {
  late MockWatchlistTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const WatchlistTvRequested());
    registerFallbackValue(const WatchlistTvInitial());
  });

  setUp(() {
    mockBloc = MockWatchlistTvBloc();
  });

  Widget makeTestableWidget() => BlocProvider<WatchlistTvBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: WatchlistTvPage()),
  );

  testWidgets('shows progress indicator when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistTvLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows TV list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistTvLoaded([]));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows message when request fails', (tester) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const WatchlistTvError("Can't get data"));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text("Can't get data"), findsOneWidget);
  });
}
