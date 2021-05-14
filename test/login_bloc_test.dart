import 'dart:async';

import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockLoginApi extends Mock implements LoginApi {}

class MockLoginResponseStreamController extends Mock
    implements StreamController<HttpEvent<LoginResponse>> {}

class MockLoginResponseStreamSink extends Mock
    implements StreamSink<HttpEvent<LoginResponse>> {}

Future<void> main() async {
  MockLoginResponseStreamController _mockController;
  MockLoginResponseStreamSink _mockSink;
  MockLoginApi _mockLoginApi;
  MockSessionProvider _mockSessionProvider;
  LoginBloc _bloc;

  setUp(() async {
    _mockController = MockLoginResponseStreamController();
    _mockSink = MockLoginResponseStreamSink();
    _mockLoginApi = MockLoginApi();
    _mockSessionProvider = MockSessionProvider();
    _bloc = LoginBloc(
        controller: _mockController,
        loginApi: _mockLoginApi,
        sessionProvider: _mockSessionProvider);

    when(_mockController.sink).thenReturn(_mockSink);
    final stream =
        StreamController<HttpEvent<LoginResponse>>.broadcast().stream;
    when(_mockController.stream).thenAnswer((_) => stream);
  });

  test('calls login api', () async {
    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockLoginApi.login(any));
  });

  test(
      'adds loading and success events to stream sink if api returns a LoginReponse',
      () async {
    when(_mockLoginApi.login(any)).thenAnswer(
        (_) async => HttpEvent<LoginResponse>(data: LoginResponse('token')));

    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockSink.add(any)).called(2);
  });

  test('adds error to stream sink if api throws an exception', () async {
    when(_mockLoginApi.login(any)).thenThrow(Error());

    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockSink.addError(any)).called(1);
  });

  test('creates session if api returns a LoginReponse', () async {
    const token = 'i am a token';

    when(_mockLoginApi.login(any)).thenAnswer(
        (_) async => HttpEvent<LoginResponse>(data: LoginResponse(token)));

    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockSessionProvider.logUserIn(token, any));
  });

  test('gets contoller stream', () async {
    await _bloc.dispose();
    expect(_bloc.stream, isA<Stream<HttpEvent<LoginResponse>>>());
  });

  test('closes stream', () async {
    await _bloc.dispose();
    verify(_mockController.close()).called(1);
  });

  tearDown(() {
    _mockController.close();
  });
}
