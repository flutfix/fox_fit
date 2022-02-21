import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/models/schedule_state.dart';
import 'package:fox_fit/models/service.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final Rx<ScheduleStateModel> scheduleState = ScheduleStateModel().obs;

  /// Получение клиента по номеру телефона
  Future<dynamic> getCustomerByPhone({
    required String phone,
    required String licenseKey,
  }) async {
    var data = await Requests.getCustomerByPhone(
      licenseKey: licenseKey,
      phone: phone,
    );
    if (data is int || data == null) {
      return data;
    } else {
      scheduleState.update((model) {
        model?.client = data;
      });
      return 200;
    }
  }

  /// Получение длительностей занятий
  Future<dynamic> getAppointmentsDurations() async {
    var data = await Requests.getAppointmentsDurations();
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
    var data = await Requests.getCustomerFitnessServices(
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
}
