import 'dart:convert';

import 'package:flutter_workshop/base/base_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';

class LoginApi extends BaseApi {
  Future<LoginResponse> login(LoginRequest request) async {
    final url = '${baseUrl}auth/login';
    final response = await post(url, request.toJson());
    final json = jsonDecode(response.body);
    return LoginResponse.fromJson(json);
  }
}