import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static Future<dynamic> request({
    required BuildContext context,
    required Future<dynamic> Function() request,
    Future<dynamic> Function(dynamic data)? handler,

    /// Повторять ли данный запрос
    bool repeat = true,
    bool skipCheck = false,
  }) async {
    do {
      dynamic data = await request();
      var connectivityResult = await Connectivity().checkConnectivity();
      
      if (data != 200 && data is! AuthDataModel) {
        /// Проверка подключения к интернету
        if (connectivityResult == ConnectivityResult.none && !skipCheck) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).error,
            message: S.of(context).no_internet_access,
          );
          await Future.delayed(const Duration(seconds: 5));

          /// Проверка на доступность сервера
        } else if (data == 503 || data == 406 || data == null) {
          await Get.offAllNamed(Routes.error);

          /// Другие ошибки сервера
        } else if (handler != null) {
          bool? repeatHadler = await handler(data);
          if (repeatHadler != null && repeatHadler == false) {
            break;
          }
        } else {
          CustomSnackbar.getSnackbar(
            title: S.of(context).server_error,
            message: S.of(context).data_download_failed,
          );
          return data;
        }
      } else {
        return data;
      }
    } while (repeat);
  }
}
