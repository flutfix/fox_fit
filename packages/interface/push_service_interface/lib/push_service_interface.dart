library push_service_interface;

abstract class IService {
  /// Иницивлизация сервиса уведомлений
  Future<void> init();

  /// Получить токен
  Future<String?> getToken();

  /// Прослушка новых уведомлений
  Future<void> listener<T>({T? plugin});

  /// Прослушка уведомлений в фоновом режиме
  Future<void> backgroundHandler();

  /// Если приложение в фоном режиме и пользователь нажимает на уведомление - его перекидывает на страницу [Уведомления]
  Future<void> onTapWhenAppFon({required Function() onTap});

  /// Если приложение закрыто и пользователь нажимает на уведомление - его перекидывает на страницу [Уведомления]
  Future<void> onTapWhenAppClosed({required Function() onTap});
}
