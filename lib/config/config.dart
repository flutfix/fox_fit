import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  static const String lastCheckNotifications = 'relevanceDate';
  static const String pathToBase = 'pathToBase';
  static const String baseAuth = 'baseAuth';
}

class Client {
  /// [Новые]
  static String fresh = '';

  /// [Назначено]
  static String assigned = '';

  /// [Проведено]
  static String conducted = '';

  /// [Постоянные]
  static String permanent = '';

  /// [Спящие]
  static String sleeping = '';

  /// [Координатор]
  static String coordinator = 'coordinator';
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
