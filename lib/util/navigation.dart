import 'package:flutter/material.dart';

class Navigation {
  Navigation(this.context);

  final BuildContext context;

  Future<T> pushNamed<T extends Object>(
    String routeName, {
    Object arguments,
    bool clearStack = false,
  }) {
    return clearStack
        ? Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => false)
        : Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Route<dynamic> makeRoute(Widget page) =>
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => page);
}
