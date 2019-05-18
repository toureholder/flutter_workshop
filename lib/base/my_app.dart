import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/base_material_app.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppDependencies _appDependencies;

  @override
  void initState() {
    super.initState();
    _appDependencies = AppDependencies(
      loginBloc: LoginBloc(),
      homeBloc: HomeBloc()
    );
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
