import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/config/api.dart';
import 'package:fox_fit/models/app_state.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:get/get.dart';

class GeneralController extends GetxController {
  final appState = AppStateModel().obs;

  @override
  void onInit() async {
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
    const String url = '${Api.url}get_customers';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(url, queryParameters: {
        'UserUid': Api.uId,
      });
      if (response.statusCode == 200) {
        List<CustomerModel> customers = [];
        List<ItemBottomBarModel> bottomBarItems = [];
        appState.update((model) {
          if (response.data['NewNotifications'] == 'True') {
            model?.isNewNotifications = true;
          } else {
            model?.isNewNotifications = false;
          }
        });
        for (var element in response.data['Customers']) {
          customers.add(CustomerModel.fromJson(element));
        }
        appState.update((model) {
          model?.customers = customers;
        });
        for (var element in response.data['PipelineStages']) {
          bottomBarItems.add(ItemBottomBarModel.fromJson(element));
        }
        appState.update((model) {
          model?.bottomBarItems = bottomBarItems;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Получение подробной информации о пользователе
  Future<dynamic> getCustomerInfo({required String clientUid}) async {
    const String url = '${Api.url}get_customer_info';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(url, queryParameters: {
        'ClientUid': clientUid,
        'UserUid': Api.uId,
      });
      if (response.statusCode == 200) {
        List<DetailedInfo> detailedInfo = [];
        List<AvailablePipelineStages> availablePipelineStages = [];

        for (var element in response.data['DetailedInfo']) {
          detailedInfo.add(DetailedInfo.fromJson(element));
        }
        for (var element in response.data['AvailablePipelineStages']) {
          availablePipelineStages
              .add(AvailablePipelineStages.fromJson(element));
        }

        appState.update((model) {
          model?.detailedInfo = detailedInfo;
          model?.availablePipelineStages = availablePipelineStages;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Сортировка активных разделов BottomBar
  void _sortBottomBarItems() {
    List<ItemBottomBarModel> sortedList = [];
    for (var element in appState.value.bottomBarItems) {
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
    for (var stage in appState.value.bottomBarItems) {
      for (var customer in appState.value.customers) {
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
}
