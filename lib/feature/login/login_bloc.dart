import 'dart:async';

import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_request.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:meta/meta.dart';

class LoginBloc {
  final LoginApi loginApi;
  final StreamController<HttpEvent<LoginResponse>> controller;
  final DiskStorageProvider diskStorageProvider;

  LoginBloc(
      {@required this.loginApi,
        @required this.controller,
        @required this.diskStorageProvider});

  Stream <HttpEvent<LoginResponse>> get stream => controller.stream;

  dispose() => controller.close();

  login({String email, String password}) async {
    try {
      final request = LoginRequest(email: email, password: password);
      controller.sink.add(HttpEvent<LoginResponse>(state: EventState.loading));
      final loginResponse = await loginApi.login(request);
      await _saveToPreferences(loginResponse);
      controller.sink.add(HttpEvent<LoginResponse>(
          state: EventState.done, data: loginResponse));
    } catch (error) {
      controller.sink.addError(error);
    }
  }

  _saveToPreferences(LoginResponse loginResponse) => Future.wait([
    diskStorageProvider.setUser(loginResponse.user),
    diskStorageProvider.setAccessToken(loginResponse.token)
  ]);
}
