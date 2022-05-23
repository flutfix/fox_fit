import 'dart:developer';

import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/api/shedule.dart';
import 'package:fox_fit/models/customer_model_state.dart';
import 'package:fox_fit/states/schedule_state.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final Rx<ScheduleState> state = ScheduleState().obs;

  /// Получение списка всех занятий за период
  Future<dynamic> getAppointments({
    required String userUid,
    required DateTime dateNow,
  }) async {
    var data = await SheduleRequests.getAppointments(
      userUid: userUid,
      dateNow: dateNow,
    );
    if (data is int || data == null) {
      return data;
    } else {
      state.update((model) {
        model?.appointments = data;
      });
      return 200;
    }
  }

  /// Получение клиента по номеру телефона
  Future<dynamic> getCustomerByPhone({
    required String phone,
    required String userUid,
  }) async {
    dynamic data = await Requests.getCustomerByPhone(
      phone: phone,
      userUid: userUid,
    );

    return data;
  }

  /// Получение длительностей занятий
  Future<dynamic> getAppointmentsDurations({
    required String userUid,
  }) async {
    dynamic data = await SheduleRequests.getAppointmentsDurations(
      userUid: userUid,
    );
    if (data is int || data == null) {
      return data;
    } else {
      state.update((model) {
        model?.appointmentsDurations = data;
      });
      return 200;
    }
  }

  /// Получение услуг
  Future<dynamic> getCustomerFitnessServices({
    required String userUid,
    required String customerUid,
    required String duration,
    required String serviceType,
    required bool split,
  }) async {
    dynamic data = await SheduleRequests.getCustomerFitnessServices(
      userUid: userUid,
      customerUid: customerUid,
      duration: duration,
      serviceType: serviceType,
      split: split,
    );
    if (data is int || data == null) {
      return data;
    } else {
      List<ServicesModel> services = data[0];
      List<PaidServiceBalance>? paidServicesBalance = data[1];

      state.update((model) {
        model?.services = services;
        if (paidServicesBalance != null) {
          model?.paidServicesBalance = paidServicesBalance;
        }
      });

      return 200;
    }
  }

  /// Запрос на создание занятия в 1с
  Future<dynamic> addAppointment({
    required String licenseKey,
    required String userUid,
    required List<CustomerModelState> customers,
    required String appointmentType,
    required bool split,
    required String dateTimeAppointment,
    required String serviceUid,
    required int capacity,
  }) async {
    dynamic data = await SheduleRequests.addAppointment(
      licenseKey: licenseKey,
      userUid: userUid,
      customers: customers,
      appointmentType: appointmentType,
      split: split,
      dateTimeAppointment: dateTimeAppointment,
      serviceUid: serviceUid,
      capacity: capacity,
    );
    return data;
  }

  /// Запрос на редактирование занятия в 1с
  Future<dynamic> editAppointment({
    required String licenseKey,
    required String userUid,
    required List<CustomerModelState> customers,
    required String appointmentUid,
    required String appointmentType,
    bool? split,
    required String dateTimeAppointment,
    required String serviceUid,
  }) async {
    dynamic data = await SheduleRequests.editAppointment(
      licenseKey: licenseKey,
      userUid: userUid,
      customers: customers,
      appointmentUid: appointmentUid,
      appointmentType: appointmentType,
      split: split,
      dateTimeAppointment: dateTimeAppointment,
      serviceUid: serviceUid,
    );
    return data;
  }

  /// Запрос на удаление занятия в 1с
  Future<dynamic> deleteAppointment({
    required String licenseKey,
    required String appointmentUid,
  }) async {
    dynamic data = await SheduleRequests.deleteAppointment(
      licenseKey: licenseKey,
      appointmentUid: appointmentUid,
    );
    return data;
  }

  void clear({
    bool appointment = false,
    bool data = true,
    bool time = true,
  }) {
    state.update((model) {
      if (appointment) {
        model?.appointment = null;
      }
      model?.clients = [];
      model?.capacity = 1;
      model?.duration = null;
      model?.split = false;
      model?.service = null;
      if (data) {
        model?.date = null;
      }
      if (time) {
        model?.time = null;
      }
      model?.appointmentRecordType = AppointmentRecordType.create;
    });
  }
}
