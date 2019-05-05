import 'dart:async';

import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';

class LoginBloc {
  final StreamController controller = StreamController<LoginResponse>();

  dispose() => controller.close();

  login(LoginRequest request) async {
    try {
      final loginResponse = await LoginApi().login(request);
      controller.sink.add(loginResponse);
    } catch (error) {
      controller.sink.addError(error);
    }
  }
}