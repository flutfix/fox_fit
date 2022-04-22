import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/notification.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';
import 'package:fox_fit/utils/prefs.dart';

///[Запросы основного функционала]
class Requests {
  /// API url
  static String url = '';

  /// Default request options
  static BaseOptions options = BaseOptions(
    baseUrl: Requests.url,
    contentType: Headers.jsonContentType,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  /// Получение разделов BottomBar и клиентов под них
  static Future<dynamic> getCustomers(
      {required String id, String? fcmToken}) async {
    String url = '${Requests.url}get_customers';

    final dioClient = Dio(Requests.options);
    String platform = '';
    String? lastCheckNotifications = await Prefs.getPrefs(
      key: Cache.lastCheckNotifications,
      prefsType: PrefsType.string,
    );
    if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'Ios';
    }
    Map<String, dynamic>? _queryParams = {
      "UserUid": id,
      "DevicePlatform": platform,
    };
    if (lastCheckNotifications != null) {
      _queryParams['LastCheckingDate'] = lastCheckNotifications;
    }
    if (fcmToken != null) {
      _queryParams['FcmToken'] = fcmToken;
    }
    try {
      var response = await dioClient.get(
        url,
        queryParameters: _queryParams,
      );
      if (response.statusCode == 200) {
        // log('${json.encode(response.data)}');
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
          response.data['UseSchedule'],
          response.data['UseSalesCoach'],
        ];
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение постоянных клиентов
  static Future<dynamic> getRegularCustomers({
    required String id,
  }) async {
    String url = '${Requests.url}get_customers';
    final dioClient = Dio(Requests.options);
    String platform = '';
    if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'Ios';
    }
    final Map<String, dynamic> _queryParams = {
      "UserUid": id,
      "GetRegularCustomersOnly": true,
      "DevicePlatform": platform,
    };

    String? lastCheckNotifications = await Prefs.getPrefs(
      key: Cache.lastCheckNotifications,
      prefsType: PrefsType.string,
    );

    if (lastCheckNotifications != null) {
      _queryParams['LastCheckingDate'] = lastCheckNotifications;
    }

    try {
      var response = await dioClient.get(
        url,
        queryParameters: _queryParams,
      );
      if (response.statusCode == 200) {
        List<CustomerModel> customers = [];

        for (var element in response.data['Customers']) {
          customers.add(CustomerModel.fromJson(element));
        }

        return customers;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение спящих клиентов
  static Future<dynamic> getOnlyInactiveCustomers({
    required String id,
  }) async {
    String url = '${Requests.url}get_customers';
    final dioClient = Dio(Requests.options);
    String platform = '';
    if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'Ios';
    }
    final Map<String, dynamic> _queryParams = {
      "UserUid": id,
      "OnlyInactiveCustomers": true,
      "DevicePlatform": platform,
    };

    String? lastCheckNotifications = await Prefs.getPrefs(
      key: Cache.lastCheckNotifications,
      prefsType: PrefsType.string,
    );

    if (lastCheckNotifications != null) {
      _queryParams['LastCheckingDate'] = lastCheckNotifications;
    }

    try {
      var response = await dioClient.get(
        url,
        queryParameters: _queryParams,
      );
      if (response.statusCode == 200) {
        List<CustomerModel> customers = [];

        for (var element in response.data['Customers']) {
          customers.add(CustomerModel.fromJson(element));
        }
        return customers;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
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

  /// Получение клиентов для рабочего стола координатора
  static Future<dynamic> getCoordinaorWorkSpace({required String id}) async {
    String url = '${Requests.url}get_customers';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": id,
        },
      );
      if (response.statusCode == 200) {
        List<CustomerModel> customers = [];

        for (var element in response.data['Customers']) {
          customers.add(CustomerModel.fromJson(element));
        }
        bool isNewNotification = false;
        if (response.data['NewNotifications'] == 'True') {
          isNewNotification = true;
        }
        return [isNewNotification, customers];
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение подробной информации о пользователе
  static Future<dynamic> getCustomerInfo({
    required String customerId,
    required String uId,
  }) async {
    String url = '${Requests.url}get_customer_info';
    final dioClient = Dio(Requests.options);
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
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Перенос клиента по воронке
  static Future<dynamic> transferClientByTrainerPipeline({
    required String userUid,
    required String customerUid,
    required String trainerPipelineStageUid,
    String? transferDate,
    String? commentText,
  }) async {
    String url = '${Requests.url}transfer_client_by_trainer_pipeline';
    final dioClient = Dio(Requests.options);
    try {
      Map<String, dynamic> queryParameters = {
        'UserUid': userUid,
        'CustomerUid': customerUid,

        /// [Uid] этапа тренерской воронки куда перемещать
        'TrainerPipelineStageUid': trainerPipelineStageUid,
        'TransferDate': transferDate,
        'CommentText': commentText,
      };

      if (transferDate == null || transferDate == '') {
        queryParameters.remove('TransferDate');
      }
      if (commentText == null || commentText == '') {
        queryParameters.remove('CommentText');
      }

      var response = await dioClient.post(
        url,
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение статистики тренера
  static Future<dynamic> getTrainerPerfomance({
    required String id,
    required int settlementDate,
  }) async {
    String url = '${Requests.url}get_trainer_performance';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": id,
          "SettlementDate": settlementDate,
        },
      );
      if (response.statusCode == 200) {
        TrainerPerfomanceModel trainerPerfomance =
            TrainerPerfomanceModel.fromJson(
                response.data['TrainerPerformance'][0]);

        return trainerPerfomance;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение всех тренеров
  static Future<dynamic> getTrainers({required String id}) async {
    String url = '${Requests.url}get_trainers';
    final dioClient = Dio(Requests.options);
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
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Передача клиента тренеру
  static Future<dynamic> transferClientToTrainer({
    required String userUid,
    required String customerUid,
    required String trainerUid,
  }) async {
    String url = '${Requests.url}transfer_client_to_trainer';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.post(url, queryParameters: {
        'UserUid': userUid,
        'CustomerUid': customerUid,
        'TrainerUid': trainerUid,
      });
      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение уведомлений
  static Future<dynamic> getNotifications({required String id}) async {
    String url = '${Requests.url}get_notifications';
    final dioClient = Dio(Requests.options);
    var now = DateTime.now();
    var monthAgo = DateTime(now.year, now.month - 1, now.day);

    ///Timestamp in seconds
    String endDate = (now.millisecondsSinceEpoch / 1000).round().toString();
    String startDate =
        (monthAgo.millisecondsSinceEpoch / 1000).round().toString();
    String? relevanceDate = await Prefs.getPrefs(
        key: Cache.lastCheckNotifications, prefsType: PrefsType.string);
    relevanceDate ??= startDate;
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": id,
          "RelevanceDate": relevanceDate,
          "StartDate": startDate,
          "EndDate": endDate,
        },
      );
      if (response.statusCode == 200) {
        List<NotificationModel> notifications = [];
        for (var element in response.data['Notifications']) {
          notifications.add(NotificationModel.fromJson(element));
        }
        return notifications;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение клиента по номеру телефона
  static Future<dynamic> getCustomerByPhone({
    required String phone,
    required String userUid,
  }) async {
    String url = '${Requests.url}get_customer_by_phone_number';
    final dioClient = Dio(Requests.options);

    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "phone_number": phone,
          "UserUid": userUid,
        },
      );

      if (response.statusCode == 200) {
        List<CustomerModel> customers = [];
        response.data['Customers'].forEach((element) {
          customers.add(CustomerModel.fromJson(element));
        });

        return customers;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }
}
