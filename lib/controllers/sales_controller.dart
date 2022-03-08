import 'dart:developer';

import 'package:fox_fit/api/sales.dart';
import 'package:fox_fit/states/sales_state.dart';
import 'package:get/get.dart';

class SalesController extends GetxController {
  final Rx<SalesState> state = SalesState().obs;

  /// Получить длительности тренировок
  Future<dynamic> getAppointmentsDurations({
    required String userUid,
  }) async {
    var data = await SalesRequests.getAppointmentsDuration(
      userUid: userUid,
    );
    if (data is int || data == null) {
      return data;
    } else {
      state.update((model) {
        model?.durations = data;
      });
      return 200;
    }
  }

  /// Получить услуги под выбранные параметры
  Future<dynamic> getServices({
    required String userUid,
  }) async {
    var data = await SalesRequests.getServices(
        userUid: userUid,
        duration: state.value.chosenDuration!,
        appointmentType: state.value.isPersonal ? 'Personal' : 'Group',
        split: state.value.isSplit,
        isStarting: state.value.isStarting);
    if (data is int || data == null) {
      return data;
    } else {
      state.update((model) {
        model?.services = data[0];
        model?.packageOfServices = data[1];
      });
      return 200;
    }
  }

  /// Выставить продажу
  Future<dynamic> addSale({
    required String userUid,
  }) async {
    var data = await SalesRequests.addSale(
      userUid: userUid,
      serviceUid: state.value.chosenService!.uid,
      customerUid: state.value.chosenCustomer!.uid,
      amount: state.value.quantity!,
      price: state.value.chosenService!.price,
    );
    if (data is int || data == null) {
      return data;
    } else {
      return 200;
    }
  }
}
