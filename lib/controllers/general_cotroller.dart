import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/api/auth.dart';
import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/states/app_state.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/coordinator_workspace.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:get/get.dart';

class GeneralController extends GetxController {
  final Rx<AppState> appState = AppState().obs;

  Future<void> initVibration() async {
    appState.update((model) {
      model?.isVibrateLoading = true;
    });

    bool _canVibrate = await Vibrate.canVibrate;

    appState.update((model) {
      model?.isCanVibrate = _canVibrate;
      model?.isVibrateLoading = false;
    });
  }

  /// Смена пароля
  Future<dynamic> changeUserPassword({
    required String key,
    required String newPass,
    required String userUid,
  }) async {
    dynamic data = await AuthRequest.changeUserPassword(
      key: key,
      newPass: newPass,
      userUid: userUid,
    );
    return data;
  }

  /// Запрос на получение основных данных, необходимых для инициализации приложения
  Future<dynamic> getCustomers({String? fcmToken}) async {
    var data = await Requests.getCustomers(
      id: getUid(role: UserRole.trainer),
      fcmToken: fcmToken,
    );
    if (data is int || data == null) {
      return data;
    } else {
      final String isNewNotifications = data[0] ?? 'False';
      final List<ItemBottomBarModel> bottomBarItems = data[1];
      final List<CustomerModel> customers = data[2];
      final bool? useSchedule = data[3];
      final bool? useSalesCoach = data[4];
      appState.update((model) {
        if (isNewNotifications == 'True') {
          model?.isNewNotifications = true;
        } else {
          model?.isNewNotifications = false;
        }
        model?.useSchedule = useSchedule ?? false;
        model?.useSalesCoach = useSalesCoach ?? false;
      });
      _setStagesPipelinesID(bottomBarItems: bottomBarItems);
      _sortBottomBarItems(bottomBarItems: bottomBarItems);
      _sortCustomers(bottomBarItems: bottomBarItems, allCutsomers: customers);

      return 200;
    }
  }

  /// Запрос на получение постоянных клиентов
  Future<dynamic> getRegularCustomers() async {
    var data =
        await Requests.getRegularCustomers(id: getUid(role: UserRole.trainer));
    if (data is int || data == null) {
      return data;
    } else {
      int stableStageIndex = appState.value.bottomBarItems
          .indexWhere((element) => element.shortName == 'Постоянные');
      String stageUid = appState.value.bottomBarItems[stableStageIndex].uid;
      var sortedCustomers = appState.value.sortedCustomers;
      sortedCustomers[stageUid] = data;
      appState.update((model) {
        model?.sortedCustomers = sortedCustomers;
      });

      return 200;
    }
  }

  /// Запрос на получение спящих клиентов
  Future<dynamic> getInactiveCustomers() async {
    var data = await Requests.getOnlyInactiveCustomers(
        id: getUid(role: UserRole.trainer));
    if (data is int || data == null) {
      return data;
    } else {
      var inactiveCustomers = data;
      appState.update((model) {
        model?.inactiveCustomers = inactiveCustomers;
      });
      return 200;
    }
  }

  /// Запрос на получение клиентов для координатора
  Future<dynamic> getCoordinaorWorkSpace() async {
    var data = await Requests.getCoordinaorWorkSpace(
        id: getUid(role: UserRole.coordinator));

    if (data is int || data == null) {
      return data;
    } else {
      final CoordinatorModel _coordinator =
          CoordinatorModel(isNewNotification: data[0], customers: data[1]);
      appState.update((model) {
        model?.coordinator = _coordinator;
      });
      return 200;
    }
  }

  /// Запрос на получение статистики тренера
  Future<dynamic> getTrainerPerfomance({
    required int perfomanceDate,
  }) async {
    var data = await Requests.getTrainerPerfomance(
      id: getUid(role: UserRole.trainer),
      settlementDate: perfomanceDate,
    );
    if (data is int || data == null) {
      return data;
    } else {
      TrainerPerfomanceModel perfomance = data;

      appState.update((model) {
        model?.trainerPerfomance = perfomance;
      });
      return 200;
    }
  }

  /// Получение подробной информации о пользователе
  Future<dynamic> getCustomerInfo({
    required String customerId,
  }) async {
    var data = await Requests.getCustomerInfo(
      customerId: customerId,
      uId: getUid(role: UserRole.trainer),
    );
    if (data is int || data == null) {
      return data;
    } else {
      final List<DetailedInfo> detailedInfo = data[0];
      final List<AvailablePipelineStages> availablePipelineStages = data[1];
      appState.update((model) {
        model?.detailedInfo = detailedInfo;
        model?.availablePipelineStages = availablePipelineStages;
      });
      return 200;
    }
  }

  /// Получение всех тренеров
  Future<dynamic> getTrainers() async {
    var data = await Requests.getTrainers(id: getUid(role: UserRole.trainer));
    if (data is int || data == null) {
      return data;
    } else {
      appState.update((model) {
        model?.availableTrainers = data;
      });
      return 200;
    }
  }

  /// Перенос клиента по воронке
  Future<dynamic> transferClientByTrainerPipeline({
    required String userUid,
    required String customerUid,
    required String trainerPipelineStageUid,
    String? transferDate,
    String? commentText,
  }) async {
    dynamic data = await Requests.transferClientByTrainerPipeline(
      userUid: userUid,
      customerUid: customerUid,
      trainerPipelineStageUid: trainerPipelineStageUid,
      transferDate: transferDate,
      commentText: commentText,
    );
    return data;
  }

  /// Передача клиента тренеру от координатора
  Future<dynamic> transferClientToTrainer({
    required String userUid,
    required String customerUid,
    required String trainerUid,
  }) async {
    dynamic data = await Requests.transferClientToTrainer(
      userUid: userUid,
      customerUid: customerUid,
      trainerUid: trainerUid,
    );
    return data;
  }

  /// Получение уведомлений
  Future<dynamic> getNotifications() async {
    var data = await Requests.getNotifications(
      id: getUid(role: UserRole.trainer),
    );
    if (data is int || data == null) {
      return data;
    } else {
      appState.update((model) {
        model?.notifications = data;
      });
      return 200;
    }
  }

  /// Получение клиента по номеру телефона
  Future<dynamic> getCustomerByPhone({required String phone}) async {
    var data = await Requests.getCustomerByPhone(
      userUid: getUid(role: UserRole.trainer),
      phone: phone,
    );
    if (data is int || data == null) {
      return data;
    } else {
      appState.update((model) {
        model?.currentCustomer = data[0];
      });
      return 200;
    }
  }

  /// Сортировка активных разделов BottomBar
  void _sortBottomBarItems({required List<ItemBottomBarModel> bottomBarItems}) {
    List<ItemBottomBarModel> sortedList = [];
    for (var element in bottomBarItems) {
      if (element.visible) {
        sortedList.add(element);
      }
      if (element.initialStage) {
        sortedList[0] = element;
      }

      /// Установка uid спящих клиентов
      if (element.name == 'Спящие клиенты') {
        Client.sleeping = element.uid;
      }
    }

    appState.update((model) {
      model?.bottomBarItems = sortedList;
    });
  }

  /// Сортировка клиентов по разделам BottomBar, где [Uid] раздела - ключ от Map
  void _sortCustomers({
    required List<ItemBottomBarModel> bottomBarItems,
    required List<CustomerModel> allCutsomers,
  }) {
    List<CustomerModel> customers = [];
    Map<String, List<CustomerModel>> sortedClients = {};
    if (appState.value.sortedCustomers[Client.permanent] != null) {
      if (appState.value.sortedCustomers[Client.permanent]!.isNotEmpty) {
        sortedClients[Client.permanent] =
            appState.value.sortedCustomers[Client.permanent]!;
      }
    }
    for (var stage in bottomBarItems) {
      for (var customer in allCutsomers) {
        if (stage.uid == customer.trainerStageUid) {
          customers.add(customer);
        }
      }
      if (customers.isNotEmpty) {
        sortedClients[stage.uid] = customers;
      }
      customers = [];
    }
    appState.update((model) {
      model?.sortedCustomers = sortedClients;
    });
  }

  /// Поиск тренеров из всего списка
  void sortTrainers({required String search}) {
    List<Trainer> trainers = [];
    if (search != '') {
      for (var trainer in appState.value.availableTrainers) {
        List<String> trainerDividers = trainer.name.split(' ');
        List<String> searchDividers = search.split(' ');

        List<bool> check = [];
        for (var searchDivider in searchDividers) {
          bool passed = false;
          for (var trainerDivider in trainerDividers) {
            if (trainerDivider
                .toLowerCase()
                .contains(searchDivider.toLowerCase())) {
              passed = true;
            }
          }
          check.add(passed);
        }
        if (!check.contains(false)) {
          trainers.add(trainer);
        }
      }

      appState.update((model) {
        model?.sortedAvailableTrainers = trainers;
      });
    } else {
      appState.update((model) {
        model?.sortedAvailableTrainers = null;
      });
    }
  }

  /// Получить [Uid] по нужной роли
  String getUid({required UserRole role}) {
    switch (role) {
      case UserRole.trainer:
        var user = appState.value.auth!.users!
            .where((element) => element.role == 'Тренер');
        return user.isNotEmpty ? user.first.uid : 'no such user role';

      case UserRole.coordinator:
        var user = appState.value.auth!.users!
            .where((element) => element.role == 'Координатор');
        return user.isNotEmpty ? user.first.uid : 'no such user role';
    }
  }

  void _setStagesPipelinesID(
      {required List<ItemBottomBarModel> bottomBarItems}) {
    /// Этапы воронки
    Client.fresh = _getStageUid(bottomBarItems, shortName: 'Новые');
    Client.assigned = _getStageUid(bottomBarItems, shortName: 'Назначено');
    Client.conducted = _getStageUid(bottomBarItems, shortName: 'Проведено');
    Client.permanent = _getStageUid(bottomBarItems, shortName: 'Постоянные');

    /// Этапы работы с клиентом
    StagePipeline.assigned =
        _getStageUid(bottomBarItems, shortName: 'Назначено');
    StagePipeline.transferringRecord =
        _getStageUid(bottomBarItems, shortName: 'Клиент перенес запись');
    StagePipeline.nonCall =
        _getStageUid(bottomBarItems, shortName: 'Невозможно дозвониться');
    StagePipeline.rejection =
        _getStageUid(bottomBarItems, shortName: 'Отказ клиента');
  }

  String _getStageUid(List<ItemBottomBarModel> bottomBarItems,
      {required String shortName}) {
    var index =
        bottomBarItems.indexWhere((element) => element.shortName == shortName);
    return bottomBarItems[index].uid;
  }
}
