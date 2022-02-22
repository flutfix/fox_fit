import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<dynamic> getPrefs({
    required String key,
    required PrefsType prefsType,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (prefsType) {
      case PrefsType.string:
        return prefs.getString(key);
      case PrefsType.boolean:
        return prefs.getBool(key);
    }
  }
}

enum PrefsType {
  string,
  boolean,
}
