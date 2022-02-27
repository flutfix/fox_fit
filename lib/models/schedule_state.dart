import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/customer_model_state.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/utils/enums.dart';

class ScheduleStateModel {
  ScheduleStateModel({
    this.appointment,
    this.clients = const [],
    this.capacity = 1,
    this.duration,
    this.split = false,
    this.service,
    this.date,
    this.time,
    this.appointmentRecordType = AppointmentRecordType.create,
    this.appointments = const [],
    this.appointmentsDurations = const [],
    this.services = const [],
    this.paidServicesBalance = const [],
  });

  /// Выбранное занятие
  AppointmentModel? appointment;

  /// Выбранные клиенты
  List<CustomerModelState> clients;

  /// Вместимость тренировки
  int capacity;

  /// Выбранная длительность тренировки
  int? duration;

  /// Выбранный тип тренировки (Персональная или Сплит)
  bool split;

  /// Выбранная услуга
  Service? service;

  /// Выбранная дата тренировки
  DateTime? date;

  /// Выбранное время тренировки
  DateTime? time;

  /// Тип записи на тренировку
  AppointmentRecordType appointmentRecordType;

  /// Список всех занятий
  List<AppointmentModel> appointments;

  /// Список длительностей занятий
  List<int> appointmentsDurations;

  /// Список всех услуг
  List<Service> services;

  /// Список оставшихся занятий
  List<PaidServiceBalance> paidServicesBalance;
}
