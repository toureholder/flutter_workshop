import 'dart:async';

import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_workshop/model/login/login_api.dart';

class MockLoginApi extends Mock implements LoginApi {}

class MockLoginResponseStreamController extends Mock
    implements StreamController<HttpEvent<LoginResponse>> {}

class MockLoginResponseStreamSink extends Mock
    implements StreamSink<HttpEvent<LoginResponse>> {}

void main() {
  MockLoginResponseStreamController _mockController;
  MockLoginResponseStreamSink _mockSink;
  MockLoginApi _mockLoginApi;
  LoginBloc _bloc;

  setUp(() {
    _mockController = MockLoginResponseStreamController();
    _mockSink = MockLoginResponseStreamSink();
    _mockLoginApi = MockLoginApi();
    _bloc = LoginBloc(controller: _mockController, loginApi: _mockLoginApi);

    when(_mockController.sink).thenReturn(_mockSink);
  });

  test('calls login api', () async {
    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockLoginApi.login(any));
  });

  test('adds events to stream sink if api returns a LoginReponse', () async {
    when(_mockLoginApi.login(any))
        .thenAnswer((_) async => LoginResponse('token', User.fake()));

    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockSink.add(any)).called(2);
  });

  test('adds error to stream sink if api throws an exception', () async {
    when(_mockLoginApi.login(any)).thenThrow(Error());

    await _bloc.login(email: 'test@test.com', password: '123456');
    verify(_mockSink.addError(any)).called(1);
  });

  tearDown(() {
    _mockController.close();
  });
}
