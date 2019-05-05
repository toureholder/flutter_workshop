import 'package:flutter/material.dart';

class Navigation {
  final BuildContext context;

  Navigation(this.context);

  push(Widget page) {
    final route = MaterialPageRoute(builder: (context) => page);
    Navigator.push(context, route);
  }
}