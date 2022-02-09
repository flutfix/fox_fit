import 'dart:developer';

import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/models/app_state.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/coordinator_workspace.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:get/get.dart';

class GeneralController extends GetxController {
  final Rx<AppStateModel> appState = AppStateModel().obs;

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
    var data = await Requests.changeUserPassword(
      key: key,
      newPass: newPass,
      userUid: userUid,
    );
    return data;
  }

  /// Запрос на получение основных данных, необходимых для инициализации приложения
  Future<dynamic> getCustomers({String? fcmToken}) async {
    var data = await Requests.getCustomers(
      id: appState.value.auth!.users![0].uid,
      fcmToken: fcmToken,
    );
    if (data is int) {
      // TODO: Обработка статус кодов != 200
      return data;
    } else {
      final String isNewNotifications = data[0];
      final List<ItemBottomBarModel> bottomBarItems = data[1];
      final List<CustomerModel> customers = data[2];

      appState.update((model) {
        if (isNewNotifications == 'True') {
          model?.isNewNotifications = true;
        } else {
          model?.isNewNotifications = false;
        }
      });

      _sortBottomBarItems(bottomBarItems: bottomBarItems);
      _sortCustomers(bottomBarItems: bottomBarItems, allCutsomers: customers);
      return 200;
    }
  }

  /// Запрос на получение постоянных клиентов
  Future<dynamic> getRegularCustomers({bool? getRegularCustomersOnly}) async {
    var data = await Requests.getRegularCustomers(
        id: appState.value.auth!.users![0].uid);
    if (data is int) {
      // TODO: Обработка статус кодов != 200
    } else {
      int stableStageIndex = appState.value.bottomBarItems
          .indexWhere((element) => element.shortName == 'Постоянные');
      String stageUid = appState.value.bottomBarItems[stableStageIndex].uid;
      var sortedCustomers = appState.value.sortedCustomers;
      sortedCustomers[stageUid] = data;
      appState.update((model) {
        model?.sortedCustomers = sortedCustomers;
      });
    }
  }

  /// Запрос на получение рабочего стола координатора
  Future<dynamic> getCoordinaorWorkSpace(
      {bool? getRegularCustomersOnly}) async {
    var data = await Requests.getCoordinaorWorkSpace(
        id: appState.value.auth!.users![1].uid);

    if (data is int) {
      // TODO: Обработка статус кодов != 200
    } else {
      final CoordinatorModel _coordinator =
          CoordinatorModel(isNewNotification: data[0], customers: data[1]);
      appState.update((model) {
        model?.coordinator = _coordinator;
      });
    }
  }

  /// Запрос на получение статистики тренера
  Future<dynamic> getTrainerPerfomance() async {
    var data = await Requests.getTrainerPerfomance(
      id: appState.value.auth!.users![0].uid,
    );
    if (data is int) {
      // TODO: Обработка статус кодов != 200
    } else {
      appState.update((model) {
        model?.trainerPerfomance = data;
      });
    }
  }

  /// Получение подробной информации о пользователе
  Future<dynamic> getCustomerInfo({
    required String customerId,
  }) async {
    var data = await Requests.getCustomerInfo(
      customerId: customerId,
      uId: appState.value.auth!.users![0].uid,
    );
    if (data is int) {
      // TODO: Обработка статус кодов != 200
    } else {
      final List<DetailedInfo> detailedInfo = data[0];
      final List<AvailablePipelineStages> availablePipelineStages = data[1];
      appState.update((model) {
        model?.detailedInfo = detailedInfo;
        model?.availablePipelineStages = availablePipelineStages;
      });
    }
  }

  /// Получение всех тренеров
  Future<dynamic> getTrainers() async {
    var data =
        await Requests.getTrainers(id: appState.value.auth!.users![0].uid);
    if (data is int) {
      // TODO: Обработка статус кодов != 200
    } else {
      appState.update((model) {
        model?.availableTrainers = data;
      });
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
    var data = await Requests.transferClientByTrainerPipeline(
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
    var data = await Requests.transferClientToTrainer(
      userUid: userUid,
      customerUid: customerUid,
      trainerUid: trainerUid,
    );
    return data;
  }

  /// Получение уведомлений
  Future<dynamic> getNotifications() async {
    var data = await Requests.getNotifications(
      id: appState.value.auth!.users![0].uid,
    );
    if (data is int) {
      // TODO: Обработка статус кодов != 200
    } else {
      appState.update((model) {
        model?.notifications = data;
      });
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
}
