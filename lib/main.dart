import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final http.Client _httpClient = http.Client();

  final SharedPreferences _sharedPreferences =
      await SharedPreferences.getInstance();

  final SharedPreferencesStorage _sharedPreferencesStorage =
      SharedPreferencesStorage(_sharedPreferences);

  final Session _session =
      Session(diskStorageProvider: _sharedPreferencesStorage);

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );

  List<SingleChildWidget> providers = [
    Provider<LoginBloc>(
      create: (_) => LoginBloc(
        controller: StreamController<HttpEvent<LoginResponse>>.broadcast(),
        loginApi: LoginApi(client: _httpClient),
        sessionProvider: _session,
      ),
    ),
    Provider<HomeBloc>(
      create: (_) => HomeBloc(
        controller: StreamController<List<Donation>>.broadcast(),
        donationApi: DonationApi(client: _httpClient),
        diskStorageProvider: _sharedPreferencesStorage,
        sessionProvider: _session,
      ),
    ),
  ];

  runApp(MyApp(dependencies: providers));
}
