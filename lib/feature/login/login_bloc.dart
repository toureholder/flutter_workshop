import 'dart:async';

import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';

class LoginBloc {
  final StreamController controller =
      StreamController<HttpEvent<LoginResponse>>();

  dispose() => controller.close();

  login(LoginRequest request) async {
    try {
      controller.sink.add(HttpEvent<LoginResponse>(state: EventState.loading));
      final loginResponse = await LoginApi().login(request);
      controller.sink.add(HttpEvent<LoginResponse>(
          state: EventState.done, data: loginResponse));
    } catch (error) {
      controller.sink.addError(error);
    }
  }
}
