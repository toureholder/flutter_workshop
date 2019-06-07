import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:mockito/mockito.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  final _mockHomeBloc = MockHomeBloc();
  final _mockLoginBloc = MockLoginBloc();
  final _mockNavigationObserver = MockNavigatorObserver();

  final _testableWidget = TestUtil.makeTestableWidget(
      subject: Home(),
      dependencies:
          AppDependencies(homeBloc: _mockHomeBloc, loginBloc: _mockLoginBloc),
      navigatorObservers: [_mockNavigationObserver]);

  final _appBar = find.byType(CustomAppBar);

  testWidgets('shows circular progress inidicator while loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testableWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('loads donations', (WidgetTester tester) async {
    await tester.pumpWidget(_testableWidget);

    verify(_mockHomeBloc.loadDonations());
  });

  testWidgets('shows list when donations are added to stream',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      final controller = StreamController<List<Donation>>.broadcast();

      when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(_testableWidget);

      controller.sink.add(Donation.fakeList());

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListView), findsOneWidget);

      controller.close();
    });
  });

  testWidgets('navigates to login screen', (WidgetTester tester) async {
    when(_mockLoginBloc.stream).thenAnswer((_) => MockLoginResponseStream());

    await tester.pumpWidget(_testableWidget);
    final loginButton = find.byKey(Home.loginButtonKey);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(_mockNavigationObserver.didPush(any, any));
    expect(find.byType(Login), findsOneWidget);
  });

  testWidgets('displays user avatar in app bar if user is logged in',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      when(_mockHomeBloc.loadCurrentUser())
          .thenAnswer((_) async => User.fake());

      await tester.pumpWidget(_testableWidget);
      await tester.pump(Duration.zero);

      expect(find.descendant(of: _appBar, matching: find.byType(CircleAvatar)),
          findsOneWidget);
    });
  });

  testWidgets('displays login button in app bar if user is not logged in',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      when(_mockHomeBloc.loadCurrentUser()).thenAnswer((_) async => null);

      await tester.pumpWidget(_testableWidget);
      await tester.pump(Duration.zero);

      final flatButton = find.byType(FlatButton);
      final text = TestUtil.findInternationalizedText('login_title');
      final textButton = find.descendant(of: flatButton, matching: text);

      expect(
          find.descendant(of: _appBar, matching: textButton), findsOneWidget);
    });
  });

  testWidgets('shows logout confirmation dialog when user taps avatar',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      when(_mockHomeBloc.loadCurrentUser())
          .thenAnswer((_) async => User.fake());

      await tester.pumpWidget(_testableWidget);
      await tester.pump(Duration.zero);

      final avatar =
          find.descendant(of: _appBar, matching: find.byType(CircleAvatar));

      await tester.tap(avatar);
      await tester.pump(Duration.zero);

      final dialog = find.byType(CustomAlertDialog);
      final title =
          TestUtil.findInternationalizedText('logout_confirmation_title');

      expect(find.descendant(of: dialog, matching: title), findsOneWidget);
    });
  });

  testWidgets('calls bloc logout with button is tapped',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      when(_mockHomeBloc.loadCurrentUser())
          .thenAnswer((_) async => User.fake());

      await tester.pumpWidget(_testableWidget);
      await tester.pump(Duration.zero);

      final avatar =
          find.descendant(of: _appBar, matching: find.byType(CircleAvatar));

      await tester.tap(avatar);
      await tester.pump(Duration.zero);

      final buttonText =
          TestUtil.findInternationalizedText('logout_confirmation');
      final button =
          find.descendant(of: find.byType(FlatButton), matching: buttonText);

      await tester.tap(button);

      verify(_mockHomeBloc.logout()).called(1);
    });
  });

  testWidgets('shows error message when an error is added to stream',
      (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      final controller = StreamController<List<Donation>>.broadcast();

      when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(_testableWidget);

      controller.sink.addError('error');

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
          find.descendant(
              of: find.byType(Center), matching: find.text('error')),
          findsOneWidget);

      controller.close();
    });
  });
}
