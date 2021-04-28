import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/fakes.dart';
import 'test_util/mocks.dart';

void main() {
  MockClient _mockClient;
  LoginApi _loginApi;
  final LoginRequest _loginRequest =
      LoginRequest(email: 'ab@cd.com', password: '123456');

  setUp(() {
    _mockClient = MockClient();
    _loginApi = LoginApi(client: _mockClient);
  });

  test('returns LoginResponse data if the http call succeeds', () async {
    when(
      _mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => http.Response(fakeLoginResponseBody, 200));

    final HttpEvent<LoginResponse> event = await _loginApi.login(_loginRequest);

    expect(event.data, isA<LoginResponse>());
    expect(event.statusCode, 200);
  });

  test('returns null data if the http call fails', () async {
    when(
      _mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => http.Response(fakeLogin422ResponseBody, 422));

    final HttpEvent<LoginResponse> event = await _loginApi.login(_loginRequest);

    expect(event.data, isA<void>());
    expect(event.statusCode, 422);
  });

  tearDown(() {
    reset(_mockClient);
  });
}
