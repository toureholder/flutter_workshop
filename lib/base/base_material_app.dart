import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/config/routes.dart';
import 'package:flutter_workshop/feature/home/home.dart';

class BaseMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        StringLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      initialRoute: Home.routeName,
      onGenerateRoute: getRouteFactory,
    );
  }
}
