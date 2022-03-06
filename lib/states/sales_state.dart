import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/service.dart';

class SalesState {
  SalesState({
    this.isPersonal = true,
    this.isSplit = false,
    this.isStarting = false,
    this.clients = const [],
    this.durations = const [],
    this.chosenDuration,
    this.services = const [],
    this.packageOfServices = const [],
    this.quantity,
    this.currentService,
  });

  /// Выбранный тип тренировки (Персональная или групповая)
  bool isPersonal;

  /// Выбранные клиенты
  List<CustomerModel> clients;

  /// Длительность
  List<dynamic> durations;
  int? chosenDuration;

  /// Услуги и пакеты
  ServicesModel? currentService;
  List<ServicesModel> services;
  List<ServicesModel> packageOfServices;

  /// Количество
  int? quantity;

  ///----[Персональная]
  /// Выбранный тип персональной тренировки (Персональная или сплит)
  bool isSplit;

  /// Продление или стартовый
  bool isStarting;

  ///----
}
