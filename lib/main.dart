import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/base/my_app.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/service/shared_preferences_storage.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  final _httpClient = http.Client();
  final _sharedPreferences = await SharedPreferences.getInstance();

  final _sharedPreferencesStorage =
      SharedPreferencesStorage(_sharedPreferences);

  final dependencies = AppDependencies(
      loginBloc: LoginBloc(
          controller: StreamController<HttpEvent<LoginResponse>>.broadcast(),
          loginApi: LoginApi(client: _httpClient),
          diskStorageProvider: _sharedPreferencesStorage),
      homeBloc: HomeBloc(
          controller: StreamController<List<Donation>>.broadcast(),
          donationApi: DonationApi(client: _httpClient),
          diskStorageProvider: _sharedPreferencesStorage));

  runApp(MyApp(dependencies: dependencies));
}
