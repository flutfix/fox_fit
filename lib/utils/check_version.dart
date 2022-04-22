import 'dart:io';

import 'package:fox_fit/models/auth_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckVersion {
  /// Проверка версии приложения для принуждения обновления
  static Future<bool> checkingApplicationVersion({
    required AuthDataModel authData,
  }) async {
    bool actualVersion = true;
    if (authData.buggedAppVersions != null) {
      if (Platform.isAndroid) {
        int indexAndroid = authData.buggedAppVersions!
            .indexWhere((element) => element.platform == 'Android');
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        List<String> currentVersion = packageInfo.version.split('.');
        List<String> buggedAppVersions =
            authData.buggedAppVersions![indexAndroid].version.split('.');
        for (int i = 0; i < currentVersion.length; i++) {
          if (int.parse(currentVersion[i]) < int.parse(buggedAppVersions[i])) {
            actualVersion = false;
          }
        }
      }
      if (Platform.isIOS) {
        int indexiOS = authData.buggedAppVersions!
            .indexWhere((element) => element.platform == 'iOS');
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        List<String> currentVersion = packageInfo.version.split('.');
        List<String> buggedAppVersions =
            authData.buggedAppVersions![indexiOS].version.split('.');
        for (int i = 0; i < currentVersion.length; i++) {
          if (int.parse(currentVersion[i]) < int.parse(buggedAppVersions[i])) {
            actualVersion = false;
          }
        }
      }
    }
    return actualVersion;
  }
}
