import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/values/strings.dart';

class TestUtil {
  static Widget makeTestableWidget(
      {Widget subject, AppDependencies dependencies}) {
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

  static Finder findInternationalizedText(String localizationKey) {
    final Map<String, String> localizationMap =
        Strings().map[localizationKey];

    return find.byElementPredicate((Element candidate) {
      if (candidate.widget is Text) {
        final Text textWidget = candidate.widget;
        if (textWidget.data != null)
          return localizationMap.containsValue(textWidget.data);
        return localizationMap.containsValue(textWidget.textSpan.toPlainText());
      } else if (candidate.widget is EditableText) {
        final EditableText editable = candidate.widget;
        return localizationMap.containsValue(editable.controller.text);
      }
      return false;
    });
  }
}
