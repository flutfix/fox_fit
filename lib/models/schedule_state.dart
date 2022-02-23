import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/utils/enums.dart';

class ScheduleStateModel {
  ScheduleStateModel({
    this.appointments = const [],
    this.uid,
    this.client,
    this.arrivalStatuses = false,
    this.duration,
    this.type = TrainingType.personal,
    this.service,
    this.date,
    this.time,
    this.appointmentsDurations = const [],
    this.services = const [],
    this.paidServicesBalance = const [],
  });

  /// Список всех занятий
  List<AppointmentModel> appointments;

  /// [uid] пользователя (тренера)
  String? uid;

  /// Выбранный [клиент]
  CustomerModel? client;

  /// Статус [прибытия] клиента
  bool arrivalStatuses;

  /// Выбранная [длительность] тренировки
  int? duration;

  /// Выбранный [тип] тренировки
  TrainingType type;

  /// Выбранная [услуга]
  Service? service;

  /// Выбранная [дата] тренировки
  DateTime? date;

  /// Выбранное [время] тренировки
  DateTime? time;

  /// Список длительностей занятий
  List<int> appointmentsDurations;

  /// Список всех услуг
  List<Service> services;

  /// Список оставшихся занятий
  List<PaidServiceBalance> paidServicesBalance;
}
