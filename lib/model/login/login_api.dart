import 'dart:convert';
import 'dart:io';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_workshop/base/base_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:meta/meta.dart';

class LoginApi extends BaseApi {
  LoginApi({@required http.Client client}) : super(client: client);

  Future<HttpEvent<LoginResponse>> login(LoginRequest request) async {
    final url = '${baseUrl}auth/login';
    final response = await post(url, request.toJson());

    LoginResponse data;

    if (response.statusCode == HttpStatus.ok)
      data = LoginResponse.fromJson(jsonDecode(response.body));

    return HttpEvent(statusCode: response.statusCode, data: data);
  }
}
