import 'dart:io';

import 'package:dio/dio.dart';

class Api {
  /// API url
  static const String url = 'http://176.99.138.90:60580/fit_3/hs/api_v1/';

  /// Id сотрудника для тестов
  static const String uId = 'e75d54e0-aa2c-11e9-ca89-ac1f6b336352';

  static BaseOptions options = BaseOptions(
    baseUrl: Api.url,
    contentType: Headers.jsonContentType,
    headers: {
      HttpHeaders.authorizationHeader: 'Basic YWRtaW46YWRtaW4=',
    },
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );
}

class AppConfig {
  /// Whatsapp url
  static const String supportUrl = 'whatsapp://send?phone=+79323005950';
}
