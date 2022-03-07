import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/models/service.dart';

///[Запросы для выставления продажи]
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

        return [services, packageOfServices];
      }
    } on DioError catch (e) {
      log('${e.response?.statusCode} - ${e.response?.statusMessage}');
      return e.response?.statusCode;
    }
  }
}
