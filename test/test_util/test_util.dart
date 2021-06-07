import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/config/routes.dart';
import 'package:flutter_workshop/values/strings.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TestUtil {
  static Widget makeTestableWidget({
    Widget? subject,
    required List<SingleChildWidget> dependencies,
    List<NavigatorObserver?>? navigatorObservers,
    Locale? testingLocale,
  }) {
    return MultiProvider(
      providers: dependencies,
      child: MaterialApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          StringLocalizationsDelegate(testingLocale: testingLocale),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        onGenerateRoute: getRouteFactory,
        home: subject,
        navigatorObservers: navigatorObservers as List<NavigatorObserver>? ?? const <NavigatorObserver>[],
      ),
    );
  }

  static Finder findInternationalizedText(String localizationKey) {
    final Map<String, String>? localizationMap = Strings().map[localizationKey];

    return find.byElementPredicate((Element candidate) {
      if (candidate.widget is Text) {
        final Text textWidget = candidate.widget as Text;
        return (textWidget.data != null)
            ? localizationMap!.containsValue(textWidget.data)
            : localizationMap!.containsValue(textWidget.textSpan!.toPlainText());
      }

      if (candidate.widget is EditableText) {
        final EditableText editable = candidate.widget as EditableText;
        return localizationMap!.containsValue(editable.controller.text);
      }

      return false;
    });
  }
}
