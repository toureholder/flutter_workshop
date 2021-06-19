import 'dart:async';

import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'test_util/fakes.dart';
import 'test_util/mocks.dart';

class MockLoginApi extends Mock implements LoginApi {}

class MockLoginResponseStreamController extends Mock
    implements StreamController<HttpEvent<LoginResponse>> {}

class MockLoginResponseStreamSink extends Mock
    implements StreamSink<HttpEvent<LoginResponse>> {}

class FakeLoginRequest extends Fake implements LoginRequest {}

class FakeLoginResponseHttpEvent extends Fake
    implements HttpEvent<LoginResponse> {}

Future<void> main() async {
  late MockLoginResponseStreamController mockController;
  late MockLoginResponseStreamSink mockSink;
  late MockLoginApi mockLoginApi;
  late MockSessionProvider mockSessionProvider;
  late LoginBloc bloc;

  setUp(() async {
    registerFallbackValue(FakeLoginRequest());
    registerFallbackValue(FakeLoginResponseHttpEvent());
    registerFallbackValue(FakeUser());
    mockController = MockLoginResponseStreamController();
    mockSink = MockLoginResponseStreamSink();
    mockLoginApi = MockLoginApi();
    mockSessionProvider = MockSessionProvider();
    bloc = LoginBloc(
        controller: mockController,
        loginApi: mockLoginApi,
        sessionProvider: mockSessionProvider);

    when(() => mockController.sink).thenReturn(mockSink);
    final stream =
        StreamController<HttpEvent<LoginResponse>>.broadcast().stream;
    when(() => mockController.stream).thenAnswer((_) => stream);

    when(() => mockController.close()).thenAnswer((_) async => null);

    when(() => mockSessionProvider.logUserIn(any(), any()))
        .thenAnswer((_) async => []);
  });

  test('calls login api', () async {
    when(() => mockLoginApi.login(any())).thenAnswer(
        (_) async => HttpEvent<LoginResponse>(data: LoginResponse('token')));

    const email = 'test@test.com';
    const password = '1234567';

    await bloc.login(email: email, password: password);

    verify(
      () => mockLoginApi.login(
        const LoginRequest(
          email: email,
          password: password,
        ),
      ),
    );
  });

  test(
      'adds loading and success events to stream sink if api returns a LoginReponse',
      () async {
    when(() => mockLoginApi.login(any())).thenAnswer(
        (_) async => HttpEvent<LoginResponse>(data: LoginResponse('token')));

    await bloc.login(email: 'test@test.com', password: '123456');
    final captured = verify(() => mockSink.add(captureAny())).captured;

    expect(captured.length, 2);

    final first = captured.first as HttpEvent<LoginResponse>;
    expect(first.state, EventState.loading);

    final last = captured.last as HttpEvent<LoginResponse>;
    expect(last.state, EventState.done);
    expect(last.data, isA<LoginResponse>());
  });

  test('adds error to stream sink if api throws an exception', () async {
    when(() => mockLoginApi.login(any())).thenThrow(Error());

    await bloc.login(email: 'test@test.com', password: '123456');
    verify(() => mockSink.addError(any())).called(1);
  });

  test('creates session with token and fake user if api returns a LoginReponse',
      () async {
    const token = 'i am a token';

    when(() => mockLoginApi.login(any())).thenAnswer(
        (_) async => HttpEvent<LoginResponse>(data: LoginResponse(token)));

    await bloc.login(email: 'test@test.com', password: '123456');
    verify(() => mockSessionProvider.logUserIn(token, const User.fake()));
  });

  test('gets contoller stream', () async {
    await bloc.dispose();
    expect(bloc.stream, isA<Stream<HttpEvent<LoginResponse>>>());
  });

  test('closes stream', () async {
    await bloc.dispose();
    verify(() => mockController.close()).called(1);
  });

  tearDown(() {
    mockController.close();
  });
}
