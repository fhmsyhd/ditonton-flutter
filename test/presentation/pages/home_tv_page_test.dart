import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/home_tv/home_tv_bloc.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeTvBloc extends MockBloc<HomeTvEvent, HomeTvState>
    implements HomeTvBloc {}

void main() {
  late MockHomeTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const HomeTvOnTheAirRequested());
    registerFallbackValue(const HomeTvState());
  });

  setUp(() {
    mockBloc = MockHomeTvBloc();
  });

  Widget makeTestableWidget() => BlocProvider<HomeTvBloc>.value(
    value: mockBloc,
    child: const MaterialApp(home: HomeTvPage()),
  );

  testWidgets('shows progress indicators when sections are loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const HomeTvState(
        onTheAirStatus: HomeTvStatus.loading,
        popularStatus: HomeTvStatus.loading,
        topRatedStatus: HomeTvStatus.loading,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('shows TV lists when sections are loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const HomeTvState(
        onTheAirStatus: HomeTvStatus.loaded,
        popularStatus: HomeTvStatus.loaded,
        topRatedStatus: HomeTvStatus.loaded,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(TvList), findsNWidgets(3));
  });

  testWidgets('shows failure messages when sections fail', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const HomeTvState(
        onTheAirStatus: HomeTvStatus.error,
        popularStatus: HomeTvStatus.error,
        topRatedStatus: HomeTvStatus.error,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed'), findsNWidgets(3));
  });
}
