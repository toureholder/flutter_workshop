import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_workshop/values/strings.dart';

const Iterable<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('pt'),
];

List<String> get supportedLanguageCodes =>
    supportedLocales.map((Locale locale) => locale.languageCode).toList();

class StringLocalizationsDelegate extends LocalizationsDelegate<L10n> {
  const StringLocalizationsDelegate({
    this.testingLocale,
  });

  final Locale? testingLocale;

  @override
  bool isSupported(Locale locale) =>
      supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<L10n> load(Locale locale) => SynchronousFuture<L10n>(L10n(
        locale,
        testingLocale: testingLocale,
      ));

  @override
  bool shouldReload(StringLocalizationsDelegate old) => false;
}

class L10n {
  L10n(
    this._locale, {
    this.testingLocale,
  });

  final Locale _locale;
  final Locale? testingLocale;
  final String defaultLanguageCode = supportedLanguageCodes.first;
  final Map<String, Map<String, String>> _localizedValues = Strings().map;

  String _get(String key) {
    if (_localizedValues[key] == null) return key;

    final languageCode = testingLocale?.languageCode ?? _locale.languageCode;

    return _localizedValues[key]![languageCode] ??
        _localizedValues[key]![defaultLanguageCode] ??
        key;
  }

  static String? getString(
    BuildContext context,
    String? key,
  ) =>
      key == null
          ? null
          : Localizations.of<L10n>(
              context,
              L10n,
            )!
              ._get(key);
}
