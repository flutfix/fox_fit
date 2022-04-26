import 'dart:developer';
import 'dart:io';

import 'package:fox_fit/models/auth_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckVersion {
  /// Проверка версии приложения для принуждения обновления
  static Future<bool> checkingApplicationVersion({
    required AuthDataModel authData,
  }) async {
    bool actualVersion = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    dynamic currentVersion = packageInfo.version.split('.');
    currentVersion = currentVersion[0] + currentVersion[1] + currentVersion[2];
    dynamic actualAppVersions = Platform.isAndroid
        ? authData.data!.vAndroid.split('.')
        : authData.data!.vApple.split('.');
    actualAppVersions =
        actualAppVersions[0] + actualAppVersions[1] + actualAppVersions[2];
    if (int.parse(currentVersion) < int.parse(actualAppVersions)) {
      actualVersion = false;
    }

    return actualVersion;
  }
}
