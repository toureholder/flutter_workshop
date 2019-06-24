import 'package:flutter/material.dart';

class Navigation {
  Navigation(this.context);

  final BuildContext context;

  Future<T> push<T extends Object>(Widget page, {bool clearStack = false}) {
    final MaterialPageRoute<T> route = _makeRoute(page);
    return clearStack
        ? Navigator.pushAndRemoveUntil(
            context, route, (Route<dynamic> route) => false)
        : Navigator.push(context, route);
  }

  Route<dynamic> _makeRoute(Widget page) =>
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => page);
}
