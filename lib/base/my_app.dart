import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/base_material_app.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key key, this.dependencies}) : super(key: key);

  final List<SingleChildWidget> dependencies;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SingleChildWidget> _appDependencies;

  @override
  void initState() {
    super.initState();
    _appDependencies = widget.dependencies;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _appDependencies,
      child: BaseMaterialApp(),
    );
  }
}
