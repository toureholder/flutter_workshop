import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'test_util/fakes.dart';
import 'test_util/mocks.dart';

void main() {
  late MockClient mockClient;
  late LoginApi loginApi;
  final LoginRequest loginRequest = LoginRequest(
    email: 'ab@cd.com',
    password: '123456',
  );

  setUp(() {
    mockClient = MockClient();
    loginApi = LoginApi(client: mockClient);
  });

  test('returns LoginResponse data if the http call succeeds', () async {
    when(
      () => mockClient.post(
        Uri.parse('https://reqres.in/api/login'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => http.Response(fakeLoginResponseBody, 200));

    final HttpEvent<LoginResponse> event = await loginApi.login(loginRequest);

    expect(event.data, isA<LoginResponse>());
    expect(event.statusCode, 200);
  });

  test('returns null data if the http call fails', () async {
    when(
      () => mockClient.post(
        Uri.parse('https://reqres.in/api/login'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => http.Response(fakeLogin422ResponseBody, 422));

    final HttpEvent<LoginResponse> event = await loginApi.login(loginRequest);

    expect(event.data, isA<void>());
    expect(event.statusCode, 422);
  });

  tearDown(() {
    reset(mockClient);
  });
}
