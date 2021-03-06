import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/coordinator_workspace.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/notification.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';

class AppState {
  AppState({
    this.isLoading = false,
    this.currentIndex = 0,
    this.isNewNotifications = false,
    this.countNewNotifications = 0,
    this.useSchedule = false,
    this.useSalesCoach = false,
    this.isCoordinator = false,
    this.isAppStateResumed = false,
    this.isCanVibrate = false,
    this.isVibrateLoading = false,
    this.auth,
    this.coordinator,
    this.customers = const [],
    this.bottomBarItems = const [],
    this.sortedCustomers = const {},
    this.detailedInfo = const [],
    this.availablePipelineStages = const [],
    this.trainerPerfomance,
    this.trainerPerfomanceMonth = const [],
    this.trainerPerfomanceTimeStamp = const [],
    this.availableTrainers = const [],
    this.sortedAvailableTrainers,
    this.currentCustomer,
    this.currentTrainer,
    this.notifications = const [],
    this.inactiveCustomers = const [],
  });

  bool isLoading;
  int currentIndex;

  /// Есть ли новые уведомления
  bool isNewNotifications;

  /// Количество новых уведомлений
  int countNewNotifications;

  /// Показывать ли раздел [Расписание]
  bool useSchedule;

  /// Показывать ли раздел [Продажи]
  bool useSalesCoach;

  /// Является ли юзер координатором
  bool isCoordinator;

  /// Для отслеживания глобального состояния приложения
  bool isAppStateResumed;

  bool isCanVibrate;
  bool isVibrateLoading;

  /// Данные авторизации
  AuthDataModel? auth;

  /// Все клиенты
  List<CustomerModel> customers;

  /// Разделы Bottom Bar
  List<ItemBottomBarModel> bottomBarItems;

  /// Отсортированные клиенты по разделам BottomBar, где ключ [Uid] раздела
  Map<String, List<CustomerModel>> sortedCustomers;

  /// Только Спящие клиенты
  List<CustomerModel> inactiveCustomers;

  /// Рабочий стол координатора
  CoordinatorModel? coordinator;

  /// Подробная информация о клиенте
  List<DetailedInfo> detailedInfo;

  /// Возможные варианты передачи клиента дальше по воронке
  List<AvailablePipelineStages> availablePipelineStages;

  /// Статистика тренера
  TrainerPerfomanceModel? trainerPerfomance;

  /// Месяцы статистики тренера
  List<String> trainerPerfomanceMonth;
  List<int> trainerPerfomanceTimeStamp;

  /// Доступные тренера
  List<Trainer> availableTrainers;

  /// Отсортированные тренера по поиску
  List<Trainer>? sortedAvailableTrainers;

  /// Отсортированные постоянные по поиску
  List<CustomerModel>? sortedPermanentCustomers;

  /// Выбранный клиент
  CustomerModel? currentCustomer;

  /// Выбранный тренер
  Trainer? currentTrainer;

  /// Список уведомлений
  List<NotificationModel> notifications;
}
