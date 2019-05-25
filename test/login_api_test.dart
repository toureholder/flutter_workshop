import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockClient _mockClient = MockClient();
  LoginApi _loginApi = LoginApi(client: _mockClient);
  LoginRequest _loginRequest =
      LoginRequest(email: 'test@test.com', password: '123456');

  test('returns a LoginResponse if the http call succeeds', () async {
    final fakeResponseBody =
        '{"firebse_auth_token":"eyJhbGciO34gryI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1id3BsZkBnaXeftHAtOTM4ZGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay1id3BsZkBnaXZhcHAtOTM4ZGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTU1ODY4ODg1MywiZXhwIjoxNTU4NjkyNDUzLCJ1aWQiOiI5In0.e-W_FwMdiZFJnJRqMX4OvhzFMteoYVX5IKx1sHgzwIXXvdM1TRT5OsnfCYEj3qjOJx91r_Q9Nd4cMReM7hD_REdhhCiDOwHJqUdKV3YlS5kMzT9QX-nd4R9sNYMAuhSWlneFF-Rm9wJ4GjJuJoCdtmgkqF4D0qwwyIz03abcQyGrU2xwvnTK6FuJtNuuOdAmPPB_e4cLxAg7aXDmUwPOp-1WVV-TYd0sh-Qj_VDb_wG_V3Im6M3AbcckUfBkcegtDJ2pHYd9kCRbTeSmGn6cQn5MewM3F9ELaN5s4AoBhCIumllijedZBxRbsnMGCwBOvxSYPNLpCCwsOs6n3XMw_g","long_lived_token":"eyJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjo5fQ.RcmFmBBcPAu8j9-GI7NJ2VcDgN7ijV_IOwgRg5K3cTe98PhX91W3wN5kFIoxS2mHbmvQ7rbpVzmgOipdGB8WJ1265Tha3jWTFBBPC-1FDh-s4hky77ppRWWHcBF1dS1aqYvh_5WGIpP1ZCdMMK3qX7ui8paRqAs58GD51qtca1U7-WG1WoFg_Dq-eKdDjr-mQs6Bvr136HITOsoO1s4BIp_viCYij_DQ4QNTlIF2LZyyf1WR5fyPjM3WU8qhIpydb2f_-V78x1TTy6zf9lkREv_FlTQ-M2LhiecDAZCuTr3F7fU8b-MDpUV0dmfQEJgG7YlTTCbWC0e57hxcYkQAng","user":{"id":9,"name":"Touré (flutter workshop)","country_calling_code":null,"phone_number":null,"image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/users%2F9%2Fphotos%2F1557445532146.jpg?alt=media\u0026token=a51f52b4-fd87-4078-89a4-27bedfc0edb8","bio":null,"admin":false,"created_at":"2019-03-27T10:44:45.939Z"}}';
    final body = anyNamed('body');
    final headers = anyNamed('headers');

    when(_mockClient.post(any, body: body, headers: headers))
        .thenAnswer((_) async => http.Response(fakeResponseBody, 200));

    expect(await _loginApi.login(_loginRequest), isA<LoginResponse>());
  });
}
