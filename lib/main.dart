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
import 'package:flutter_workshop/service/session.dart';
import 'package:flutter_workshop/service/shared_preferences_storage.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final http.Client _httpClient = http.Client();
  final SharedPreferences _sharedPreferences =
      await SharedPreferences.getInstance();

  final SharedPreferencesStorage _sharedPreferencesStorage =
      SharedPreferencesStorage(_sharedPreferences);

  final Session _session =
      Session(diskStorageProvider: _sharedPreferencesStorage);

  final AppDependencies dependencies = AppDependencies(
      loginBloc: LoginBloc(
          controller: StreamController<HttpEvent<LoginResponse>>.broadcast(),
          loginApi: LoginApi(client: _httpClient),
          sessionProvider: _session),
      homeBloc: HomeBloc(
          controller: StreamController<List<Donation>>.broadcast(),
          donationApi: DonationApi(client: _httpClient),
          diskStorageProvider: _sharedPreferencesStorage,
          sessionProvider: _session));

  runApp(MyApp(dependencies: dependencies));
}
