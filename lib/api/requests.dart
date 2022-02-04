import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requests {
  /// Авторизация
  static Future<dynamic> auth({
    required String phone,
    required String pass,
  }) async {
    final now = DateTime.now();
    var format = DateFormat('dd.MM.y');
    final String formattedDate = format.format(now);
    String key = _getBase64String(text: '$phone$formattedDate');
    key = _getBase64String(text: key);

    const String url = '${Api.authurl}check_credentials';

    final dioClient = Dio(Api.authOptions);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "Secret_kralka": key,
          "Phone": phone,
          "Password": pass,
        },
      );
      if (response.statusCode == 200) {
        _setPrefs(phone: phone, pass: pass);
        AuthDataModel authData = AuthDataModel();
        authData = AuthDataModel.fromJson(response.data);
        return authData;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static String _getBase64String({required String text}) {
    final bytes = utf8.encode(text);
    return base64Encode(bytes);
  }

  /// Получение разделов BottomBar и клиентов под них
  static Future<dynamic> getCustomers({
    required String id,
  }) async {
    const String url = '${Api.url}get_customers';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": id,
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

        return [
          response.data['NewNotifications'],
          bottomBarItems,
          customers,
        ];
      } else {
        return response.statusCode;
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
  static Future<dynamic> getTrainerPerfomance({required String id}) async {
    const String url = '${Api.url}get_trainer_performance';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": id,
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
        return perfomance;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Получение подробной информации о пользователе
  static Future<dynamic> getCustomerInfo({
    required String customerId,
    required String uId,
  }) async {
    const String url = '${Api.url}get_customer_info';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(url, queryParameters: {
        'ClientUid': customerId,
        'UserUid': uId,
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
        return [detailedInfo, availablePipelineStages];
      } else {
        return response.statusCode;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Получение подробной информации о пользователе
  static Future<dynamic> getTrainers({required String id}) async {
    const String url = '${Api.url}get_trainers';
    final dioClient = Dio(Api.options);
    try {
      var response = await dioClient.get(url, queryParameters: {
        'UserUid': id,
      });
      if (response.statusCode == 200) {
        List<Trainer> availableTrainers = [];

        for (var element in response.data) {
          availableTrainers.add(Trainer.fromJson(element));
        }
        return availableTrainers;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> _setPrefs({
    required String phone,
    required String pass,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthorized', true);
    prefs.setString('phone', phone);
    prefs.setString('pass', pass);
  }

  static Future<dynamic> getPrefs({
    required String key,
    required PrefsType prefsType,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (prefsType) {
      case PrefsType.string:
        return prefs.getString(key);
      case PrefsType.boolean:
        return prefs.getBool(key);
    }
  }
}

enum PrefsType {
  string,
  boolean,
}
