import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/base_material_app.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';

class MyApp extends StatefulWidget {
  final AppDependencies dependencies;

  const MyApp({Key key, this.dependencies}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppDependencies _appDependencies;

  @override
  void initState() {
    super.initState();
    _appDependencies = widget.dependencies;
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
