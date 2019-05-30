import 'package:flutter/material.dart';

class Navigation {
  final BuildContext context;

  Navigation(this.context);

  push(Widget page, {bool clearStack = false}) {
    final route = _makeRoute(page);
    return clearStack
        ? Navigator.pushAndRemoveUntil(
            context, route, (route) => false)
        : Navigator.push(context, route);
  }

  pushReplacement(Widget page) =>
      Navigator.pushReplacement(context, _makeRoute(page));

  _makeRoute(Widget page) => MaterialPageRoute(builder: (context) => page);
}
