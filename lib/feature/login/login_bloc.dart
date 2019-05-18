import 'dart:async';

import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';

class LoginBloc {
  final StreamController _controller =
      StreamController<HttpEvent<LoginResponse>>.broadcast();

  get stream => _controller.stream;

  dispose() => _controller.close();

  login({String email, String password}) async {
    try {
      final request = LoginRequest(email: email, password: password);
      _controller.sink.add(HttpEvent<LoginResponse>(state: EventState.loading));
      final loginResponse = await LoginApi().login(request);
      print('token: ${loginResponse.token}');
      _controller.sink.add(HttpEvent<LoginResponse>(
          state: EventState.done, data: loginResponse));
    } catch (error) {
      _controller.sink.addError(error);
    }
  }
}
