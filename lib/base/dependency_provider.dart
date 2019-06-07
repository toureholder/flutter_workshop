import 'package:flutter/material.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';

class DependencyProvider extends InheritedWidget {
  const DependencyProvider({
    Key key,
    @required Widget child,
    this.dependencies,
  })  : assert(child != null),
        super(key: key, child: child);

  final AppDependencies dependencies;

  static DependencyProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DependencyProvider)
        as DependencyProvider;
  }

  @override
  bool updateShouldNotify(DependencyProvider old) => true;
}

class AppDependencies {
  final LoginBloc loginBloc;
  final HomeBloc homeBloc;

  AppDependencies({this.loginBloc, this.homeBloc});
}
