import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/dependencies.dart';
import 'package:flutter_workshop/base/my_app.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<SingleChildWidget> providers = await getDependencies();

  runApp(MyApp(dependencies: providers));
}
