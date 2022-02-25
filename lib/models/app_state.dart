import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/coordinator_workspace.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/notification.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';

class AppStateModel {
  AppStateModel({
    this.isLoading = false,
    this.currentIndex = 0,
    this.isNewNotifications = false,
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
    this.trainerPerfomance = const [],
    this.trainerPerfomanceMonth = const [],
    this.availableTrainers = const [],
    this.sortedAvailableTrainers,
    this.currentCustomer,
    this.currentTrainer,
    this.notifications = const [],
    this.inactiveCustomers = const [],
  });

  bool isLoading;
  int currentIndex;
  bool isNewNotifications;
  bool isCoordinator;
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
  List<TrainerPerfomanceModel> trainerPerfomance;

  /// Месяцы статистики тренера
  List<String> trainerPerfomanceMonth;

  /// Доступные тренера
  List<Trainer> availableTrainers;

  /// Отсортированные тренера по поиску
  List<Trainer>? sortedAvailableTrainers;

  /// Выбранный клиент
  CustomerModel? currentCustomer;

  /// Выбранный тренер
  Trainer? currentTrainer;

  /// Список уведомлений
  List<NotificationModel> notifications;
}
