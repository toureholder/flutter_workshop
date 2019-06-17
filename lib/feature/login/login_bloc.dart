import 'dart:async';

import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/service/session_provider.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:meta/meta.dart';

class LoginBloc {
  final LoginApi loginApi;
  final StreamController<HttpEvent<LoginResponse>> controller;
  final SessionProvider sessionProvider;

  LoginBloc(
      {@required this.loginApi,
      @required this.controller,
      @required this.sessionProvider});

  Stream<HttpEvent<LoginResponse>> get stream => controller.stream;

  dispose() => controller.close();

  login({String email, String password}) async {
    try {
      final request = LoginRequest(email: email, password: password);

      controller.sink.add(HttpEvent.loading());

      final HttpEvent<LoginResponse> event = await loginApi.login(request);

      if (event.data != null) await _saveToPreferences(event.data);

      controller.sink.add(event);
    } catch (error) {
      controller.sink.addError(error);
    }
  }

  _saveToPreferences(LoginResponse loginResponse) =>
      sessionProvider.logUserIn(loginResponse);
}
