import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/customer_model_state.dart';

import 'package:fox_fit/models/service.dart' as service_model;

/// [Запросы для расписания]
class SheduleRequests {
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
    required bool split,
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
          // 'Split': split,
        },
      );

      if (response.statusCode == 200) {
        List<service_model.ServicesModel> services = [];
        List<service_model.PaidServiceBalance> paidServicesBalance = [];

        for (var service in response.data['Services']) {
          services.add(service_model.ServicesModel.fromJson(service));
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

  /// Создание тренировки
  static Future<dynamic> addAppointment({
    required String licenseKey,
    required String userUid,
    required List<CustomerModelState> customers,
    required String appointmentType,
    required bool split,
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

    log('${licenseKey}');
    log('${userUid}');
    log('${appointmentType}');
    log('${split}');
    log('${dateTimeAppointment}');
    log('${serviceUid}');
    log('${capacity}');
    log('${customersList}');

    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          'LicenseKey': licenseKey,
          'UserUid': userUid,
          'AppointmentType': appointmentType,
          'Split': split,
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

  /// Редактирование тренировки
  static Future<dynamic> editAppointment({
    required String licenseKey,
    required String userUid,
    required List<CustomerModelState> customers,
    required String appointmentUid,
    required String appointmentType,
    bool? split,
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

    log('split ${split}');

    try {
      var response = await dioClient.post(
        url,
        queryParameters: {
          'LicenseKey': licenseKey,
          'UserUid': userUid,
          'AppointmentUid': appointmentUid,
          'AppointmentType': appointmentType,
          if (split != null) 'Split': split,
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

  /// Удаление тренировки
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
}
