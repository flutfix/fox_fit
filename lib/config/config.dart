import 'dart:io';

import 'package:dio/dio.dart';

class Api {
  /// API url
  static const String url = 'http://176.99.138.90:60580/fit_3/hs/api_v1/';
  static const String authurl = 'http://zbs-service.ru:8080/SERVICE/hs/tp_v1/';

  static BaseOptions options = BaseOptions(
    baseUrl: Api.url,
    contentType: Headers.jsonContentType,
    headers: {
      HttpHeaders.authorizationHeader: 'Basic YWRtaW46YWRtaW4=',
    },
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  static BaseOptions authOptions = BaseOptions(
    baseUrl: Api.url,
    contentType: Headers.jsonContentType,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );
}

class AppConfig {
  /// Whatsapp url
  static const String supportUrl = 'whatsapp://send?phone=+79323005950';
}

class Cashe{
  static const String isAuthorized = 'isAuthorized';

}
