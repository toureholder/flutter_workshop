import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/config/l10n.dart';

class TestUtil {
  static Widget makeTestableWidget({Widget subject, AppDependencies dependencies}) {
    return DependencyProvider(
      dependencies: dependencies,
      child: MaterialApp(
        localizationsDelegates: [
          const StringLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocales.supportedLocales,
        home: subject,
      ),
    );
  }
}
