import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/models/app_state.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:get/get.dart';

class GeneralController extends GetxController {
  final Rx<AppStateModel> appState = AppStateModel().obs;
  static GeneralController controller = Get.put(GeneralController());

  @override
  Future<void> onInit() async {
    appState.update((model) {
      model?.isLoading = true;
    });
    await _initApp();
    _sortBottomBarItems();
    _sortCustomers();

    appState.update((model) {
      model?.isLoading = false;
    });
    super.onInit();
  }

  /// Запрос на получение основных данных, необходимых для инициализации приложения
  Future<dynamic> _initApp() async {
    await Requests.getCustomers();
  }

  /// Запрос на получение статистики тренера
  Future<dynamic> getTrainerPerfomance() async {
    await Requests.getTrainerPerfomance();
  }

  /// Получение подробной информации о пользователе
  Future<dynamic> getCustomerInfo({required String clientUid}) async {
    await Requests.getCustomerInfo(clientUid: clientUid);
  }

  /// Получение всех тренеров
  Future<dynamic> getTrainers() async {
    await Requests.getTrainers();
  }

  /// Сортировка активных разделов BottomBar
  void _sortBottomBarItems() {
    List<ItemBottomBarModel> sortedList = [];

    for (var element in controller.appState.value.bottomBarItems) {
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
  void _sortCustomers() {
    List<CustomerModel> customers = [];
    Map<String, List<CustomerModel>> sortedClients = {};
    for (var stage in controller.appState.value.bottomBarItems) {
      for (var customer in controller.appState.value.customers) {
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
      for (var trainer in controller.appState.value.availableTrainers) {
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
