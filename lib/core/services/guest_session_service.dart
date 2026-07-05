import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class GuestSessionService {
  GuestSessionService(this._prefs);

  final SharedPreferences _prefs;
  bool _isGuest = false;

  bool get isGuest => _isGuest;

  Future<void> init() async {
    _isGuest = _prefs.getBool(AppConstants.guestModeKey) ?? false;
  }

  Future<void> enterGuestMode() async {
    await _prefs.setBool(AppConstants.guestModeKey, true);
    _isGuest = true;
  }

  Future<void> exitGuestMode() async {
    await _prefs.setBool(AppConstants.guestModeKey, false);
    _isGuest = false;
  }
}
