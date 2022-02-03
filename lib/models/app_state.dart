import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/trainer_stats.dart';

class AppStateModel {
  AppStateModel({
    this.isLoading = false,
    this.currentIndex = 0,
    this.isNewNotifications = false,
    this.customers = const [],
    this.bottomBarItems = const [],
    this.sortedCustomers = const {},
    this.detailedInfo = const [],
    this.availablePipelineStages = const [],
    this.trainerPerfomance = const [],
  });

  bool isLoading;
  int currentIndex;
  bool isNewNotifications;

  /// Все клиенты
  List<CustomerModel> customers;

  /// Разделы Bottom Bar
  List<ItemBottomBarModel> bottomBarItems;

  /// Отсортированные клиенты по разделам BottomBar, где ключ [Uid] раздела
  Map<String, List<CustomerModel>> sortedCustomers;

  /// Подробная информация о клиенте
  List<DetailedInfo> detailedInfo;

  /// Возможные варианты передачи клиента дальше по воронке
  List<AvailablePipelineStages> availablePipelineStages;

  /// Статистика тренера
  List<TrainerPerfomanceModel> trainerPerfomance;
}
