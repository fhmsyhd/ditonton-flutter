import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects_tv.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockBloc;

  TvDetailState loadedState({
    bool isAdded = false,
    TvWatchlistActionStatus actionStatus = TvWatchlistActionStatus.idle,
    String actionMessage = '',
  }) => TvDetailState(
    detailStatus: TvDetailStatus.loaded,
    tv: testTvDetail,
    recommendationStatus: TvRecommendationStatus.loaded,
    isAddedToWatchlist: isAdded,
    watchlistActionStatus: actionStatus,
    watchlistMessage: actionMessage,
  );

  setUpAll(() {
    registerFallbackValue(const TvDetailRequested(0));
    registerFallbackValue(const TvDetailState());
  });

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget() => BlocProvider<TvDetailBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: TvDetailPage(id: 1)),
  );

  testWidgets('shows add icon when TV is not in watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(loadedState());
    await tester.pumpWidget(makeTestableWidget());
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('shows check icon when TV is in watchlist', (tester) async {
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
    verify(() => mockBloc.add(TvWatchlistAdded(testTvDetail))).called(1);
  });

  testWidgets('shows Snackbar after successful watchlist action', (
    tester,
  ) async {
    final initialState = loadedState();
    final successState = loadedState(
      isAdded: true,
      actionStatus: TvWatchlistActionStatus.success,
      actionMessage: 'Added to Watchlist',
    );
    whenListen(
      mockBloc,
      Stream<TvDetailState>.fromIterable([successState]),
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
      actionStatus: TvWatchlistActionStatus.error,
      actionMessage: 'Failed',
    );
    whenListen(
      mockBloc,
      Stream<TvDetailState>.fromIterable([errorState]),
      initialState: initialState,
    );
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
