import 'package:fox_fit/controllers/general_cotroller.dart';

class CountNewNotificationService {
  static int badge(GeneralController controller) {
    // Сокращение количесвта уведомлений до максимально отражаемого числа
    int countNewNotifications = 0;
    if (controller.appState.value.countNewNotifications > 99) {
      countNewNotifications = 99;
    } else {
      countNewNotifications = controller.appState.value.countNewNotifications;
    }
    return countNewNotifications;
  }
}
