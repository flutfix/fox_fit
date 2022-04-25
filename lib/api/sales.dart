import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/models/service.dart';

///[Запросы выставления продажи]
class SalesRequests {
  /// Получение длительности
  static Future<dynamic> getAppointmentsDuration({
    required String userUid,
  }) async {
    String url = '${Requests.url}get_appointments_durations';
    final dioClient = Dio(Requests.options);

    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": userUid,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        Requests.putSupportMessage(
          queryType: 'get_appointments_durations',
          httpCode: response.statusCode.toString(),
          messageText: response.statusMessage!,
        );
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Получение услуг и пакетов
  static Future<dynamic> getServices({
    required String userUid,
    required int duration,
    required String appointmentType,
    required bool split,
    required bool isStarting,
  }) async {
    String url = '${Requests.url}get_services';
    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.get(
        url,
        queryParameters: {
          "UserUid": userUid,
          "Duration": duration,
          "AppointmentType": appointmentType,
          "Split": split,
          "StartingServices": isStarting,
        },
      );

      if (response.statusCode == 200) {
        List<ServicesModel> services = [];
        List<ServicesModel> packageOfServices = [];

        for (var element in response.data['Services']) {
          services.add(ServicesModel.fromJson(element));
        }
        for (var element in response.data['PackageOfServices']) {
          packageOfServices.add(ServicesModel.fromJson(element));
        }

        /// Сортировка списков по возрастанию цены
        services.sort(((a, b) => a.price.compareTo(b.price)));
        packageOfServices.sort(((a, b) => a.price.compareTo(b.price)));

        return [services, packageOfServices];
      } else {
        Requests.putSupportMessage(
          queryType: 'get_services',
          httpCode: response.statusCode.toString(),
          messageText: response.statusMessage!,
        );
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }

  /// Выставить продажу
  static Future<dynamic> addSale({
    required String userUid,
    required String serviceUid,
    required String customerUid,
    required int amount,
    required int price,
  }) async {
    String url = '${Requests.url}add_sale';

    final dioClient = Dio(Requests.options);
    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          "UserUid": userUid,
          "ServiceUid": serviceUid,
          "CustomerUid": customerUid,
          "Amount": amount,
          "Price": price,
        },
      );

      if (response.statusCode == 200) {
        return 200;
      } else {
        Requests.putSupportMessage(
          queryType: 'add_sale',
          httpCode: response.statusCode.toString(),
          messageText: response.statusMessage!,
        );
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }
}
