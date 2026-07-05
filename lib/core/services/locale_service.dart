import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocaleService extends ChangeNotifier {
  LocaleService(this._prefs) {
    final saved = _prefs.getString(AppConstants.localeKey);
    if (saved != null) {
      _locale = Locale(saved);
    }
  }

  final SharedPreferences _prefs;
  Locale _locale = const Locale(AppConstants.defaultLocale);

  Locale get locale => _locale;

  bool get isRtl => _locale.languageCode == 'ar';

  Future<void> setLocale(Locale locale) async {
    if (!AppConstants.supportedLocales.contains(locale.languageCode)) {
      return;
    }
    _locale = locale;
    await _prefs.setString(AppConstants.localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final next = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(next);
  }
}
