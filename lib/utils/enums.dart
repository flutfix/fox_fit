import 'package:fox_fit/config/assets.dart';

class Enums {
  /// Для получения иконки стадии воронки по [IconUid]
  static String getIconStage(String iconUid) {
    switch (iconUid) {
      case 'e8af182e':
        return Images.assigned;
      case 'e8b2d9c8':
        return Images.refresh;
      case 'e8acaa26':
        return Images.phoneMinus;
      case 'e8b420f8':
        return Images.cross;
      default:
        return Images.assigned;
    }
  }
}
