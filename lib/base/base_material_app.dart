import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/config/routes.dart';
import 'package:flutter_workshop/feature/home/home.dart';

class BaseMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        StringLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      theme: ThemeData(
        primaryColor: const Color(0xFF4A91E2),
        backgroundColor: const Color(0xFF4A91E2),
        accentColor: const Color(0xFF1D4371),
      ),
      initialRoute: Home.routeName,
      onGenerateRoute: getRouteFactory,
    );
  }
}
