import 'package:flutter/material.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/util/navigation.dart';
import 'package:provider/provider.dart';

MaterialPageRoute getRouteFactory(settings) {
  MaterialPageRoute route;
  switch (settings.name) {
    case Home.routeName:
      {
        route = Navigation.makeRoute(Consumer<HomeBloc>(
          builder: (context, bloc, child) => Home(bloc: bloc),
        ));
      }
      break;

    case Login.routeName:
      {
        route = Navigation.makeRoute(Consumer<LoginBloc>(
          builder: (context, bloc, child) => Login(bloc: bloc),
        ));
      }
      break;

    case Detail.routeName:
      {
        final DetailArguments args = settings.arguments;
        route = Navigation.makeRoute(Detail(
          donation: args.donation,
        ));
      }
      break;
  }

  return route;
}
