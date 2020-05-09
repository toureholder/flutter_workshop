import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  MockLoginBloc _mockLoginBloc;
  MockHomeBloc _mockHomeBloc;
  MockNavigatorObserver _mockNavigationObserver;
  Widget _testableWidget;
  Finder _emailField;
  Finder _passwordField;
  Finder _submitButton;
  Finder _passwordVisibilityToggle;
  StreamController<HttpEvent<LoginResponse>> _streamController;

  setUp(() {
    _mockLoginBloc = MockLoginBloc();
    _mockHomeBloc = MockHomeBloc();
    _mockNavigationObserver = MockNavigatorObserver();
    _streamController = StreamController<HttpEvent<LoginResponse>>.broadcast();

    _testableWidget = TestUtil.makeTestableWidget(
        subject: Login(
          bloc: _mockLoginBloc,
        ),
        dependencies: [
          Provider<HomeBloc>(create: (_) => _mockHomeBloc),
        ],
        navigatorObservers: <NavigatorObserver>[
          _mockNavigationObserver
        ]);

    _emailField = find.byKey(Login.emailFieldKey);
    _passwordField = find.byKey(Login.passwordFieldKey);
    _submitButton = find.byKey(Login.submitButtonKey);
    _passwordVisibilityToggle = find.byKey(Login.passwordVisibilityToggledKey);

    when(_mockLoginBloc.stream).thenAnswer((_) => _streamController.stream);
  });

  group('attempts login', () {
    testWidgets('attempts login if email and password are valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String email = 'test@test.com';
      const String password = 'qwertyuiop';

      await tester.enterText(_emailField, email);
      await tester.enterText(_passwordField, password);
      await tester.tap(_submitButton);

      verify(_mockLoginBloc.login(email: email, password: password));
    });

    testWidgets('does not attempt login if email and password are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      await tester.tap(_submitButton);

      verifyNever(_mockLoginBloc.login(email: '', password: ''));
    });

    testWidgets('does not attempt login if email is not a valid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String email = 'invalid email';
      const String password = 'qwertyuiop';

      await tester.enterText(_emailField, email);
      await tester.enterText(_passwordField, password);
      await tester.tap(_submitButton);

      verifyNever(_mockLoginBloc.login(email: email, password: password));
    });

    testWidgets('does not attempt login if password is too short',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String email = 'test@test.com';
      const String password = '123';

      await tester.enterText(_emailField, email);
      await tester.enterText(_passwordField, password);
      await tester.tap(_submitButton);

      verifyNever(_mockLoginBloc.login(email: email, password: password));
    });
  });

  group('shows validation messages', () {
    testWidgets('shows invalid email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String email = 'invalid email';
      const String password = 'qwertyuiop';

      await tester.enterText(_emailField, email);
      await tester.enterText(_passwordField, password);
      await tester.tap(_submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_email_invalid');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows required email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String password = 'qwertyuiop';

      await tester.enterText(_passwordField, password);
      await tester.tap(_submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_email_required');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows password too short error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String email = 'test@test.com';
      const String password = '123';

      await tester.enterText(_emailField, email);
      await tester.enterText(_passwordField, password);
      await tester.tap(_submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_password_too_short');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows password required error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      const String email = 'test@test.com';

      await tester.enterText(_emailField, email);
      await tester.tap(_submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_password_required');

      expect(errorMessage, findsOneWidget);
    });
  });

  testWidgets('toggles password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(_testableWidget);

    final Finder passwordIsVisibleIcon =
        find.byKey(const Key(loginPasswordVisibilityToggleObscureValueKey));
    final Finder passwordIsObscuredIcon =
        find.byKey(const Key(loginPasswordVisibilityToggleVisibleValueKey));

    expect(passwordIsObscuredIcon, findsNothing);
    expect(passwordIsVisibleIcon, findsOneWidget);

    await tester.tap(_passwordVisibilityToggle);

    await tester.pumpAndSettle();

    expect(passwordIsObscuredIcon, findsOneWidget);
    expect(passwordIsVisibleIcon, findsNothing);
  });

  group('handles login stream events', () {
    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      _streamController.sink
          .add(HttpEvent<LoginResponse>(state: EventState.loading));
      await tester.pump(Duration.zero);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to home screen when login succeeds',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);
      _streamController.sink.add(HttpEvent<LoginResponse>(
          statusCode: HttpStatus.ok,
          data: LoginResponse('token', User.fake())));
      await tester.pump(Duration.zero);
      verify(_mockNavigationObserver.didPush(any, any));
    });

    testWidgets('shows alert dialog when login fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);
      _streamController.sink.add(
          HttpEvent<LoginResponse>(statusCode: HttpStatus.unprocessableEntity));
      await tester.pump(Duration.zero);
      final Finder dialog = find.byType(CustomAlertDialog);
      final Finder content =
          TestUtil.findInternationalizedText('login_error_bad_credentials');
      expect(find.descendant(of: dialog, matching: content), findsOneWidget);
    });
  });

  tearDown(() {
    _streamController.close();
  });
}
