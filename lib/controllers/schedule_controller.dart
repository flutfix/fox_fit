import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/schedule_state.dart';
import 'package:fox_fit/models/service.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final Rx<ScheduleStateModel> scheduleState = ScheduleStateModel().obs;

  /// Получение списка всех занятий за период
  Future<dynamic> getAppointments({
    required String userUid,
    required DateTime dateNow,
  }) async {
    var data = await Requests.getAppointments(
      userUid: userUid,
      dateNow: dateNow,
    );
    if (data is int || data == null) {
      return data;
    } else {
      scheduleState.update((model) {
        model?.appointments = data;
      });
      return 200;
    }
  }

  /// Получение клиента по номеру телефона
  Future<dynamic> getCustomerByPhone({
    required String phone,
    required String licenseKey,
  }) async {
    dynamic data = await Requests.getCustomerByPhone(
      licenseKey: licenseKey,
      phone: phone,
    );

    return data;
  }

  /// Получение длительностей занятий
  Future<dynamic> getAppointmentsDurations() async {
    dynamic data = await Requests.getAppointmentsDurations();
    if (data is int || data == null) {
      return data;
    } else {
      scheduleState.update((model) {
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
  }) async {
    dynamic data = await Requests.getCustomerFitnessServices(
      userUid: userUid,
      customerUid: customerUid,
      duration: duration,
      serviceType: serviceType,
    );
    if (data is int || data == null) {
      return data;
    } else {
      List<Service> services = data[0];
      List<PaidServiceBalance>? paidServicesBalance = data[1];

      scheduleState.update((model) {
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
    required List<CustomerModel> customers,
    required bool arrivalStatus,
    required String appointmentType,
    required String dateTimeAppointment,
    required String serviceUid,
    required int capacity,
  }) async {
    dynamic data = await Requests.addAppointment(
      licenseKey: licenseKey,
      userUid: userUid,
      customers: customers,
      arrivalStatus: arrivalStatus,
      appointmentType: appointmentType,
      dateTimeAppointment: dateTimeAppointment,
      serviceUid: serviceUid,
      capacity: capacity,
    );
    return data;
  }
}
