import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/widgets/snackbar.dart';

class ErrorHandler {
  static Future<dynamic> loadingData({
    required BuildContext context,
    required Future<dynamic> Function() request,

    /// Повторять ли данный запрос
    bool repeat = true,
  }) async {
    while (true) {
      dynamic data = await request();
      var connectivityResult = await Connectivity().checkConnectivity();
      if (data != 200) {
        /// Проверка подключения к интернету
        if (connectivityResult == ConnectivityResult.none) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).error,
            message: S.of(context).no_internet_access,
          );
          if (!repeat) {
            break;
          }
          await Future.delayed(const Duration(seconds: 5));

          /// Проверка на доступность сервера
        } else if (data == 503) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).error,
            message: S.of(context).server_navailable,
          );

          /// Другие ошибки сервера
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
    }
  }

  static Future<dynamic> singleRequest({
    required BuildContext context,
    required Future<dynamic> Function() request,
    void Function(dynamic data)? handler,
    bool skipCheck = false,
    bool canVibrate = false,
  }) async {
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
      } else if (data == 503) {
        CustomSnackbar.getSnackbar(
          title: S.of(context).error,
          message: S.of(context).server_navailable,
        );

        /// Неверный логин или пароль
      } else if (data == 401) {
        if (canVibrate) {
          Vibrate.feedback(FeedbackType.success);
        }
        CustomSnackbar.getSnackbar(
          title: S.of(context).login_exeption,
          message: S.of(context).wrong_login_or_pass,
        );

        /// Сценарий поведения после ошибки
      } else {
        if (handler != null) {
          handler(data);
        }
        return data;
      }
    } else {
      return data;
    }
  }
}
