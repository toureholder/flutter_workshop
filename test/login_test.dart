import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  late MockLoginBloc mockLoginBloc;
  late Widget testableWidget;
  late Finder emailField;
  late Finder passwordField;
  late Finder submitButton;
  late Finder passwordVisibilityToggle;
  late StreamController<HttpEvent<LoginResponse>> streamController;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    streamController = StreamController<HttpEvent<LoginResponse>>.broadcast();

    testableWidget = TestUtil.makeTestableWidget(
      subject: Login(
        bloc: mockLoginBloc,
      ),
      dependencies: [
        Provider<HomeBloc?>(create: (_) => null),
      ],
      testingLocale: supportedLocales.first,
    );

    emailField = find.byKey(Login.emailFieldKey);
    passwordField = find.byKey(Login.passwordFieldKey);
    submitButton = find.byKey(Login.submitButtonKey);
    passwordVisibilityToggle = find.byKey(Login.passwordVisibilityToggledKey);

    when(() => mockLoginBloc.stream).thenAnswer((_) => streamController.stream);

    when(() => mockLoginBloc.login(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenAnswer((_) async => null);
  });

  group('attempts login', () {
    testWidgets('attempts login if email and password are valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'test@test.com';
      const String password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      verify(() => mockLoginBloc.login(email: email, password: password));
    });

    testWidgets('does not attempt login if email and password are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(submitButton);

      verifyNever(() => mockLoginBloc.login(email: '', password: ''));
    });

    testWidgets('does not attempt login if email is not a valid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'invalid email';
      const String password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      verifyNever(() => mockLoginBloc.login(email: email, password: password));
    });

    testWidgets('does not attempt login if password is too short',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'test@test.com';
      const String password = '123';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      verifyNever(() => mockLoginBloc.login(email: email, password: password));
    });
  });

  group('shows validation messages', () {
    testWidgets('shows invalid email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'invalid email';
      const String password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_email_invalid');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows required email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String password = 'qwertyuiop';

      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_email_required');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows password too short error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'test@test.com';
      const String password = '123';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_password_too_short');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows password required error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'test@test.com';

      await tester.enterText(emailField, email);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = TestUtil.findInternationalizedText(
          'validation_message_password_required');

      expect(errorMessage, findsOneWidget);
    });
  });

  testWidgets('toggles password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    final Finder passwordIsVisibleIcon =
        find.byKey(const Key(loginPasswordVisibilityToggleObscureValueKey));
    final Finder passwordIsObscuredIcon =
        find.byKey(const Key(loginPasswordVisibilityToggleVisibleValueKey));

    expect(passwordIsObscuredIcon, findsNothing);
    expect(passwordIsVisibleIcon, findsOneWidget);

    await tester.tap(passwordVisibilityToggle);

    await tester.pumpAndSettle();

    expect(passwordIsObscuredIcon, findsOneWidget);
    expect(passwordIsVisibleIcon, findsNothing);
  });

  group('handles login stream events', () {
    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      streamController.sink.add(
        HttpEvent<LoginResponse>(state: EventState.loading),
      );

      await tester.pump(Duration.zero);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to home screen when login succeeds',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      streamController.sink.add(
        HttpEvent<LoginResponse>(
          statusCode: HttpStatus.ok,
          data: LoginResponse('token'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('shows alert dialog when login fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      streamController.sink.add(
        HttpEvent<LoginResponse>(statusCode: HttpStatus.badRequest),
      );

      await tester.pump(Duration.zero);

      final Finder dialog = find.byType(CustomAlertDialog);
      final Finder content = TestUtil.findInternationalizedText(
        'login_error_bad_credentials',
      );

      expect(
        find.descendant(
          of: dialog,
          matching: content,
        ),
        findsOneWidget,
      );
    });
  });

  tearDown(() {
    streamController.close();
  });
}
