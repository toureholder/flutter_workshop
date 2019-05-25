import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mockito/mockito.dart';

import 'test_util/test_util.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  final _mockLoginBloc = MockLoginBloc();

  final testableWidget = TestUtil.makeTestableWidget(
      subject: Login(),
      dependencies: AppDependencies(loginBloc: _mockLoginBloc));

  final emailField = find.byKey(Login.emailFieldKey);
  final passwordField = find.byKey(Login.passwordFieldKey);
  final submitButton = find.byKey(Login.submitButtonKey);

  group('attempts login', () {
    testWidgets('attempts login if email and password are valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final email = 'test@test.com';
      final password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      verify(_mockLoginBloc.login(email: email, password: password));
    });

    testWidgets('does not attempt login if email and password are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(submitButton);

      verifyNever(_mockLoginBloc.login(email: '', password: ''));
    });

    testWidgets('does not attempt login if email is not a valid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final email = 'invalid email';
      final password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      verifyNever(_mockLoginBloc.login(email: email, password: password));
    });

    testWidgets('does not attempt login if password is too short',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final email = 'test@test.com';
      final password = '123';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      verifyNever(_mockLoginBloc.login(email: email, password: password));
    });
  });

  group('shows validation messages', () {
    testWidgets('shows invalid email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final email = 'invalid email';
      final password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final errorMessage = TestUtil.findInternationalizedText(
          'validation_message_email_invalid');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows required email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final password = 'qwertyuiop';

      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final errorMessage = TestUtil.findInternationalizedText(
          'validation_message_email_required');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows password too short error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final email = 'test@test.com';
      final password = '123';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final errorMessage = TestUtil.findInternationalizedText(
          'validation_message_password_too_short');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows password required error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final email = 'test@test.com';

      await tester.enterText(emailField, email);
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final errorMessage = TestUtil.findInternationalizedText(
          'validation_message_password_required');

      expect(errorMessage, findsOneWidget);
    });
  });

  testWidgets('shows circular progress inidicator when loading',
      (WidgetTester tester) async {
    final controller = StreamController<HttpEvent<LoginResponse>>();

    when(_mockLoginBloc.stream).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(testableWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    controller.sink.add(HttpEvent<LoginResponse>(state: EventState.loading));
    await tester.pump(Duration.zero);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    controller.sink.add(HttpEvent<LoginResponse>(
        state: EventState.done, data: LoginResponse('token', User.fake())));
    await tester.pump(Duration.zero);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    controller.close();
  });
}
