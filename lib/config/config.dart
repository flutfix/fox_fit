import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Канал уведомлений для андройд
class AppConfig {
  static const AndroidNotificationChannel pushChannel =
      AndroidNotificationChannel(
    'default_notification_channel',
    'Notifications',
    description: 'This channel is used for notifications.',
    importance: Importance.max,
  );
}

/// Кэш ключи
class Cache {
  static const String isAuthorized = 'isAuthorized';
  static const String phone = 'phone';
  static const String pass = 'pass';
  static const String lastCheckNotifications = 'relevanceDate';
  static const String pathToBase = 'pathToBase';
  static const String baseAuth = 'baseAuth';
}

/// К какому разделу воронки продаж относится  клиент
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
  static String coordinator = '';
}

/// Для перемещения клиента по воронке
class StagePipeline {
  /// [Назначено]
  static String assigned = '';

  /// [Перенесено]
  static String transferringRecord = '';

  /// [Недозвон]
  static String nonCall = '';

  /// [Отказ клиента]
  static String rejection = '';

  /// [Координатор]
  static String coordinator = '';
}
