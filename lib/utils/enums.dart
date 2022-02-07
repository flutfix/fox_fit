import 'package:fox_fit/config/assets.dart';

class Enums {
  /// Для получения иконки стадии воронки по [IconUid]
  static String getIconStage({required String iconUid}) {
    switch (iconUid) {

      /// Назначена стартовая тренировка
      case 'e8af182e': //TODO: Поменять на расширенный вариант
        return Images.assigned;

      /// Клиент перенёс запись
      case 'e8b2d9c8':
        // case 'e8b2d9c8-1550-11ec-d58b-ac1f6b336352':
        return Images.refresh;

      /// Невозможно дозвониться
      case 'e8acaa26':
        // case 'e8acaa26-1550-11ec-d58b-ac1f6b336352':
        return Images.phoneMinus;

      /// Отказ клиента
      case 'e8b420f8':
        // case 'e8b420f8-1550-11ec-d58b-ac1f6b336352':
        return Images.cross;
      default:
        return Images.assigned;
    }
  }

  /// Для отображения комментария
  static bool getIsDisplayComment({required String stageUid}) {
    switch (stageUid) {

      /// Назначена стартовая тренировка
      case 'e8af182e': //TODO: Поменять на расширенный вариант
        return true;

      /// Клиент перенёс запись
      case 'e8b2d9c8':
        // case 'e8b2d9c8-1550-11ec-d58b-ac1f6b336352':
        return false;

      /// Невозможно дозвониться
      case 'e8acaa26':
        // case 'e8acaa26-1550-11ec-d58b-ac1f6b336352':
        return false;

      /// Отказ клиента
      case 'e8b420f8':
        // case 'e8b420f8-1550-11ec-d58b-ac1f6b336352':
        return true;
      default:
        return false;
    }
  }
}
