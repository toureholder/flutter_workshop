import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_workshop/values/strings.dart';

class StringLocalizationsDelegate extends LocalizationsDelegate<L10n> {
  const StringLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocales.supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<L10n> load(Locale locale) => SynchronousFuture<L10n>(L10n(locale));

  @override
  bool shouldReload(StringLocalizationsDelegate old) => false;
}

class L10n {
  L10n(this.locale);

  final Locale locale;
  final String defaultLanguageCode = AppLocales.supportedLanguageCodes.first;
  static Map<String, Map<String, String>> _localizedValues = Strings.map;

  String _get(String key) {
    if (_localizedValues[key] == null) return key;

    return _localizedValues[key][locale.languageCode] ??
        _localizedValues[key][defaultLanguageCode] ??
        key;
  }

  static String getString(BuildContext context, String key) =>
      key == null ? null : Localizations.of<L10n>(context, L10n)._get(key);
}

class AppLocales {
  static const supportedLocales = [
    const Locale('en'),
    const Locale('pt'),
  ];

  static List<String> get supportedLanguageCodes =>
      supportedLocales.map((locale) => locale.languageCode).toList();
}
