import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/config/config.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_data.dart';

///[Запросы авторизации]
class AuthRequest {
  static const String authurl = 'http://zbs-service.ru:8080/SERVICE/hs/tp_v1/';

  /// Request options for auth
  static BaseOptions authOptions = BaseOptions(
    baseUrl: AuthRequest.authurl,
    contentType: Headers.jsonContentType,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  /// Авторизация
  static Future<dynamic> auth({
    required String phone,
    required String pass,
  }) async {
    final now = DateTime.now().toUtc();
    var format = DateFormat('dd.MM.y');
    final String formattedDate = format.format(now);
    String key = _getBase64String(text: '$phone$formattedDate');
    key = _getBase64String(text: key);
    const String url = '${AuthRequest.authurl}check_credentials';

    final dioClient = Dio(AuthRequest.authOptions);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "Secret_kralka": key,
          "Phone": phone,
          "Password": pass,
        },
      );
      if (response.statusCode == 200) {
        _setUser(phone: phone, pass: pass);
        AuthDataModel authData = AuthDataModel();
        authData = AuthDataModel.fromJson(response.data);
        return authData;
      } else {
        Requests.putSupportMessage(
          queryType: 'check_credentials',
          httpCode: response.statusCode.toString(),
          messageText: response.statusMessage!,
        );
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Смена пароля
  static Future<dynamic> changeUserPassword({
    required String key,
    required String newPass,
    required String userUid,
  }) async {
    const String url = '${AuthRequest.authurl}change_user_password';

    final dioClient = Dio(AuthRequest.authOptions);
    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          "LicenseKey": key,
          "NewPassword": newPass,
          "UserUid": userUid,
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      }else {
        Requests.putSupportMessage(
          queryType: 'change_user_password',
          httpCode: response.statusCode.toString(),
          messageText: response.statusMessage!,
        );
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  static String _getBase64String({required String text}) {
    final bytes = utf8.encode(text);
    return base64Encode(bytes);
  }

  /// Занесение пользователя в локальное хранилище устройства
  static Future<void> _setUser({
    String? phone,
    required String pass,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Cache.isAuthorized, true);
    if (phone != null) {
      prefs.setString(Cache.phone, phone);
    }
    prefs.setString(Cache.pass, pass);
  }
}
