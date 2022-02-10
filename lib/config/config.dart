import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  static const AndroidNotificationChannel pushChannel =
      AndroidNotificationChannel(
    'default_notification_channel',
    'Notifications',
    description: 'This channel is used for notifications.',
    importance: Importance.max,
  );
}

class Cache {
  static const String isAuthorized = 'isAuthorized';
  static const String phone = 'phone';
  static const String pass = 'pass';
  static const String relevanceDate = 'relevanceDate';
}

class PipeLine {
  /// [Новые]
  static const String freshStage = 'e8a7b9e4-1550-11ec-d58b-ac1f6b336352';
}

class StagePipeline {
  /// [Назначено]
  static const String assigned = 'e8af182e-1550-11ec-d58b-ac1f6b336352';

  /// [Перенесено]
  static const String transferringRecord =
      'e8b2d9c8-1550-11ec-d58b-ac1f6b336352';

  /// [Недозвон]
  static const String nonCall = 'e8acaa26-1550-11ec-d58b-ac1f6b336352';

  /// [Отказ клиента]
  static const String rejection = 'e8b420f8-1550-11ec-d58b-ac1f6b336352';

  /// [Координатор]
  static const String coordinator = 'coordinator';
}
