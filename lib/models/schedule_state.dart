import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/customer_model_state.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/utils/enums.dart';

class ScheduleStateModel {
  ScheduleStateModel({
    this.appointments = const [],
    this.appointment,
    this.clients,
    this.capacity = 1,
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

  /// Выбранное [занятие]
  AppointmentModel? appointment;

  /// Выбранные [клиенты]
  List<CustomerModelState>? clients;

  /// [Вместимость] тренировки
  int capacity;

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
