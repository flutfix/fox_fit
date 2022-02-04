import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';
import 'package:get/get.dart';

class Requests {
  static GeneralController controller = Get.put(GeneralController());

  /// Получение разделов BottomBar и клиентов под них
  static Future<dynamic> getCustomers() async {
    const String url = '${Api.url}get_customers';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": Api.uId,
        },
      );
      if (response.statusCode == 200) {
        List<CustomerModel> customers = [];
        List<ItemBottomBarModel> bottomBarItems = [];

        for (var element in response.data['Customers']) {
          customers.add(CustomerModel.fromJson(element));
        }
        for (var element in response.data['PipelineStages']) {
          bottomBarItems.add(ItemBottomBarModel.fromJson(element));
        }

        bottomBarItems.add(getLastStageBottomBar);
        controller.appState.update(
          (model) {
            if (response.data['NewNotifications'] == 'True') {
              model?.isNewNotifications = true;
            } else {
              model?.isNewNotifications = false;
            }
            model?.customers = customers;
            model?.bottomBarItems = bottomBarItems;
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static ItemBottomBarModel get getLastStageBottomBar {
    return ItemBottomBarModel(
      icon: Images.still,
      name: 'Eщё',
      shortName: 'Ещё',
      visible: true,
    );
  }

  /// Получение воронки конверсии тренера
  static Future<dynamic> getTrainerPerfomance() async {
    const String url = '${Api.url}get_trainer_performance';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": Api.uId,
        },
      );
      if (response.statusCode == 200) {
        List<TrainerPerfomanceModel> perfomance = [];
        int index = 0;
        for (var element in response.data['TrainerPerformance']) {
          if (index == response.data['TrainerPerformance'].length - 1) {
            perfomance.add(
              TrainerPerfomanceModel.fromJson(
                element,
                isCurrentMonth: true,
              ),
            );
          } else {
            perfomance.add(TrainerPerfomanceModel.fromJson(element));
          }
          index++;
        }
        controller.appState.update((model) {
          model?.trainerPerfomance = perfomance;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Получение подробной информации о пользователе
  static Future<dynamic> getCustomerInfo({required String clientUid}) async {
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

        controller.appState.update((model) {
          model?.detailedInfo = detailedInfo;
          model?.availablePipelineStages = availablePipelineStages;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Получение подробной информации о пользователе
  static Future<dynamic> getTrainers() async {
    const String url = '${Api.url}get_trainers';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(url, queryParameters: {
        'UserUid': Api.uId,
      });
      if (response.statusCode == 200) {
        List<Trainer> availableTrainers = [];

        for (var element in response.data) {
          availableTrainers.add(Trainer.fromJson(element));
        }

        controller.appState.update((model) {
          model?.availableTrainers = availableTrainers;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
