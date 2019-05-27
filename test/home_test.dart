import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:mockito/mockito.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

void main() {
  final _mockHomeBloc = MockHomeBloc();
  final _mockNavigationObserver = MockNavigatorObserver();

  final testableWidget = TestUtil.makeTestableWidget(
      subject: Home(),
      dependencies:
          AppDependencies(homeBloc: _mockHomeBloc, loginBloc: MockLoginBloc()),
      navigatorObservers: [_mockNavigationObserver]);

  testWidgets('shows circular progress inidicator while loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('loads donations', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    verify(_mockHomeBloc.loadDonations());
  });

  testWidgets('shows list when donations are added to stream',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      final controller = StreamController<List<Donation>>.broadcast();

      when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(testableWidget);

      controller.sink.add(Donation.fakeList());

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListView), findsOneWidget);

      controller.close();
    });
  });

  testWidgets('navigates to login screen', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);
    final loginButton = find.byKey(Home.loginButtonKey);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(_mockNavigationObserver.didPush(any, any));
    expect(find.byType(Login), findsOneWidget);
  });
}
