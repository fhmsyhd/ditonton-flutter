import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:ditonton/presentation/pages/on_the_air_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnTheAirTvBloc extends MockBloc<OnTheAirTvEvent, OnTheAirTvState>
    implements OnTheAirTvBloc {}

void main() {
  late MockOnTheAirTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const OnTheAirTvRequested());
    registerFallbackValue(const OnTheAirTvInitial());
  });

  setUp(() {
    mockBloc = MockOnTheAirTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<OnTheAirTvBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const OnTheAirTvLoading());

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const OnTheAirTvLoaded([]));

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when error', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const OnTheAirTvError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
