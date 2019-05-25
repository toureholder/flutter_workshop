import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements http.Client {}

main() {
  MockClient _mockClient = MockClient();
  LoginApi _loginApi = LoginApi(client: _mockClient);
  LoginRequest _loginRequest =
      LoginRequest(email: 'test@test.com', password: '123456');

  test('returns a LoginResponse if the http call succeeds', () async {
    final fakeResponseBody =
        '{"long_lived_token":"eyJhbGciO9.eyJpc3MXJlY.e-XMw_g","user":{"id":9,"name":"Touré (flutter workshop)","country_calling_code":null,"phone_number":null,"image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/users%2F9%2Fphotos%2F1557445532146.jpg?alt=media\u0026token=a51f52b4-fd87-4078-89a4-27bedfc0edb8","bio":null,"admin":false,"created_at":"2019-03-27T10:44:45.939Z"}}';
    final body = anyNamed('body');
    final headers = anyNamed('headers');

    when(_mockClient.post(any, body: body, headers: headers))
        .thenAnswer((_) async => http.Response(fakeResponseBody, 200));

    expect(await _loginApi.login(_loginRequest), isA<LoginResponse>());
  });
}
