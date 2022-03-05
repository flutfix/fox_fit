import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/utils/enums.dart';

class AppointmentModel {
  late final String appointmentUid;
  late final int capacity;
  late final String room;
  late final AppointmentType appointmentType;
  late final DateTime startDate;
  late final DateTime endDate;
  late final Service service;
  late final List<CustomerModel> customers;
  late final List<ArrivalStatuses> arrivalStatuses;

  AppointmentModel({
    this.appointmentUid = '',
    this.capacity = 1,
    this.room = '',
    this.appointmentType = AppointmentType.personal,
    required this.startDate,
    required this.endDate,
    required this.service,
    required this.customers,
    required this.arrivalStatuses,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    appointmentUid = json['AppointmentUid'] ?? '';
    capacity = json['Capacity'] != null ? int.parse(json['Capacity']) : 1;
    room = json['Room'] ?? '';
    appointmentType = json['AppointmentType'] != null
        ? Enums.getAppointmentType(appointmentTypeString: json['AppointmentType'])
        : AppointmentType.personal;
    startDate = DateTime.fromMillisecondsSinceEpoch(
      int.parse(json['StartDate']) * 1000,
    );
    endDate = DateTime.fromMillisecondsSinceEpoch(
      int.parse(json['EndDate']) * 1000,
    );

    service =
        json['Service'] != null ? Service.fromJson(json['Service']) : Service();

    customers = [];
    if (json['Customers'] != null) {
      json['Customers'].forEach((v) {
        customers.add(CustomerModel.fromJson(v));
      });
    }

    arrivalStatuses = [];
    if (json['ArrivalStatuses'] != null) {
      json['ArrivalStatuses'].forEach((v) {
        arrivalStatuses.add(ArrivalStatuses.fromJson(v));
      });
    }
  }
}

class ArrivalStatuses {
  late final String customerUid;
  late final bool status;
  late final String paymentStatus;

  ArrivalStatuses({
    this.customerUid = '',
    this.status = false,
    this.paymentStatus = '',
  });

  ArrivalStatuses.fromJson(Map<String, dynamic> json) {
    customerUid = json['CustomerUid'] ?? '';
    status = json['Status'] ?? false;
    paymentStatus = json['PaymentStatus'] ?? '';
  }
}
