import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/models/available_pipeline_stages.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/customer_model_state.dart';
import 'package:fox_fit/models/detail_info.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/models/notification.dart';
import 'package:fox_fit/models/service.dart' as service_model;
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/models/trainer_stats.dart';
import 'package:fox_fit/utils/prefs.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requests {
  /// API url
  static String url = '';
  static const String authurl = 'http://zbs-service.ru:8080/SERVICE/hs/tp_v1/';

  /// Default request options
  static BaseOptions options = BaseOptions(
    baseUrl: Requests.url,
    contentType: Headers.jsonContentType,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  /// Request options for auth
  static BaseOptions authOptions = BaseOptions(
    baseUrl: Requests.url,
    contentType: Headers.jsonContentType,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  /// Авторизация
  static Future<dynamic> auth({
    required String phone,
    required String pass,
  }) async {
    final now = DateTime.now().toUtc();
    var format = DateFormat('dd.MM.y');
    final String formattedDate = format.format(now);
    String key = _getBase64String(text: '$phone$formattedDate');
    key = _getBase64String(text: key);

    const String url = '${Requests.authurl}check_credentials';

    final dioClient = Dio(Requests.authOptions);
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
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Смена пароля
  static Future<dynamic> changeUserPassword({
    required String key,
    required String newPass,
    required String userUid,
  }) async {
    const String url = '${Requests.authurl}change_user_password';

    final dioClient = Dio(Requests.authOptions);
    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          "LicenseKey": key,
          "NewPassword": newPass,
          "UserUid": userUid,
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  static String _getBase64String({required String text}) {
    final bytes = utf8.encode(text);
    return base64Encode(bytes);
  }

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

  /// Получение постоянных клиентов
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

  /// Получение воронки конверсии тренера
  static Future<dynamic> getTrainerPerfomance({required String id}) async {
    String url = '${Requests.url}get_trainer_performance';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": id,
        },
      );

      if (response.statusCode == 200) {
        List<TrainerPerfomanceModel> trainerPerfomance = [];
        List<String> trainerPerfomanceMonth = [];

        for (var element in response.data['TrainerPerformance']) {
          trainerPerfomance.add(
            TrainerPerfomanceModel.fromJson(element),
          );
          trainerPerfomanceMonth.add(element["Month"]);
        }

        return [trainerPerfomance, trainerPerfomanceMonth];
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

  /// Получение списка всех занятий за период
  static Future<dynamic> getAppointments({
    required String userUid,
    required DateTime dateNow,
  }) async {
    String url = '${Requests.url}get_appointments';
    final dioClient = Dio(Requests.options);

    /// Конвертация даты в формат Timestamp
    DateTime dateStart = DateTime(dateNow.year, dateNow.month, dateNow.day);
    DateTime dateEnd = DateTime(dateNow.year, dateNow.month, dateNow.day + 1);
    String timestampDateStart =
        dateStart.millisecondsSinceEpoch.toString().substring(0, 10);
    String timestampDateEnd =
        dateEnd.millisecondsSinceEpoch.toString().substring(0, 10);

    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": userUid,
          "start_date": timestampDateStart,
          "end_date": timestampDateEnd,
        },
      );

      if (response.statusCode == 200) {
        List<AppointmentModel> appointments = [];
        for (var element in response.data['Appointments']) {
          appointments.add(AppointmentModel.fromJson(element));
        }

        return appointments;
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
        CustomerModel customer =
            CustomerModel.fromJson(response.data['Customers'][0]);

        return customer;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение длительностей занятий
  static Future<dynamic> getAppointmentsDurations() async {
    String url = '${Requests.url}get_appointments_durations';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.get(url);
      if (response.statusCode == 200) {
        List<int> appointmentsDurations = [];
        for (int duration in response.data) {
          appointmentsDurations.add(duration);
        }
        return appointmentsDurations;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение услуг для занятий
  static Future<dynamic> getCustomerFitnessServices({
    required String userUid,
    required String customerUid,
    required String duration,
    required String serviceType,
  }) async {
    String url = '${Requests.url}get_customer_fitness_services';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          'UserUid': userUid,
          'CustomerUid': customerUid,
          'Duration': duration,
          'ServiceType': serviceType,
        },
      );

      if (response.statusCode == 200) {
        List<service_model.Service> services = [];
        List<service_model.PaidServiceBalance> paidServicesBalance = [];

        for (var service in response.data['Services']) {
          services.add(service_model.Service.fromJson(service));
        }
        if (response.data['PaidServicesBalance'] != null) {
          for (var paidServiceBalance in response.data['PaidServicesBalance']) {
            paidServicesBalance.add(
              service_model.PaidServiceBalance.fromJson(paidServiceBalance),
            );
          }
        }

        return [services, paidServicesBalance];
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Запрос на создание занятия в 1с
  static Future<dynamic> addAppointment({
    required String licenseKey,
    required String userUid,
    required List<CustomerModelState> customers,
    required String appointmentType,
    required String dateTimeAppointment,
    required String serviceUid,
    required int capacity,
  }) async {
    String url = '${Requests.url}add_appointment';
    final dioClient = Dio(Requests.options);

    List<Map<String, dynamic>> customersList = [];

    for (var customer in customers) {
      customersList.add(
        {
          'CustomerUid': customer.model.uid,
          'ArrivalStatus': customer.arrivalStatus,
        },
      );
    }

    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          'LicenseKey': licenseKey,
          'UserUid': userUid,
          'AppointmentType': appointmentType,
          'DateTimeAppointment': dateTimeAppointment,
          'ServiceUid': serviceUid,
          'Capacity': capacity,
        },
        data: {
          'Customers': customersList,
        },
      );
      
      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Запрос на редактирование занятия в 1с
  static Future<dynamic> editAppointment({
    required String licenseKey,
    required String userUid,
    required List<CustomerModelState> customers,
    required String appointmentUid,
    required String appointmentType,
    required String dateTimeAppointment,
    required String serviceUid,
  }) async {
    String url = '${Requests.url}update_appointment';
    final dioClient = Dio(Requests.options);

    List<Map<String, dynamic>> customersList = [];

    for (var customer in customers) {
      customersList.add(
        {
          'CustomerUid': customer.model.uid,
          'ArrivalStatus': customer.arrivalStatus,
        },
      );
    }

    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          'LicenseKey': licenseKey,
          'UserUid': userUid,
          'AppointmentUid': appointmentUid,
          'AppointmentType': appointmentType,
          'DateTimeAppointment': dateTimeAppointment,
          'ServiceUid': serviceUid,
        },
        data: {
          'Customers': customersList,
        },
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Запрос на удаление занятия в 1с
  static Future<dynamic> deleteAppointment({
    required String licenseKey,
    required String appointmentUid,
  }) async {
    String url = '${Requests.url}cancel_appointment';
    final dioClient = Dio(Requests.options);

    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          'LicenseKey': licenseKey,
          'AppointmentUid': appointmentUid,
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  static Future<void> _setPrefs({
    String? phone,
    required String pass,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Cache.isAuthorized, true);
    if (phone != null) {
      prefs.setString(Cache.phone, phone);
    }
    prefs.setString(Cache.pass, pass);
  }
}
