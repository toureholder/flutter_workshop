import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/base_material_app.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:flutter_workshop/model/login/login_api.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppDependencies _appDependencies;

  @override
  void initState() {
    super.initState();
    final httpClient = http.Client();

    _appDependencies = AppDependencies(
        loginBloc: LoginBloc(
            controller: StreamController<HttpEvent<LoginResponse>>.broadcast(),
            loginApi: LoginApi(client: httpClient)),
        homeBloc: HomeBloc(
            controller: StreamController<List<Donation>>(),
            donationApi: DonationApi(client: httpClient)));
  }

  @override
  void dispose() {
    _appDependencies.loginBloc.dispose();
    _appDependencies.homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DependencyProvider(
      dependencies: _appDependencies,
      child: BaseMaterialApp(),
    );
  }
}
