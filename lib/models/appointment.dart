import 'package:fox_fit/models/customer.dart';

class AppointmentModel {
  late String appointmentUid;
  late String capacity;
  late String room;
  late String appointmentType;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  Service? service = Service();
  List<CustomerModel>? customers = [];
  List<ArrivalStatuses>? arrivalStatuses = [];

  AppointmentModel({
    this.appointmentUid = '',
    this.capacity = '',
    this.room = '',
    this.appointmentType = '',
    this.startDate,
    this.endDate,
    this.service,
    this.customers,
    this.arrivalStatuses,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    appointmentUid = json['AppointmentUid'];
    capacity = json['Capacity'];
    room = json['Room'];
    appointmentType = json['AppointmentType'];
    startDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['StartDate']) * 1000);
    endDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(json['EndDate']) * 1000);
    service =
        json['Service'] != null ? Service.fromJson(json['Service']) : Service();
    if (json['Customers'] != null) {
      customers = [];
      json['Customers'].forEach((v) {
        customers!.add(CustomerModel.fromJson(v));
      });
    } else {
      customers = [];
    }
    if (json['ArrivalStatuses'] != null) {
      arrivalStatuses = [];
      json['ArrivalStatuses'].forEach((v) {
        arrivalStatuses!.add(ArrivalStatuses.fromJson(v));
      });
    } else {
      arrivalStatuses = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['AppointmentUid'] = appointmentUid;
    data['Capacity'] = capacity;
    data['Room'] = room;
    data['AppointmentType'] = appointmentType;
    data['StartDate'] = startDate;
    data['EndDate'] = endDate;
    if (service != null) {
      data['Service'] = service!.toJson();
    }
    if (customers != null) {
      data['Customers'] = customers!.map((v) => v.toJson()).toList();
    }
    if (arrivalStatuses != null) {
      data['ArrivalStatuses'] =
          arrivalStatuses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  late String name;
  late String uid;
  late String duration;
  late bool trial;

  Service({
    this.name = '',
    this.uid = '',
    this.duration = '',
    this.trial = false,
  });

  Service.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? '';
    uid = json['Uid'] ?? '';
    duration = json['Duration'] ?? '';
    trial = json['Trial'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Name'] = name;
    data['Uid'] = uid;
    data['Duration'] = duration;
    data['Trial'] = trial;
    return data;
  }
}

class ArrivalStatuses {
  late String customerUid;
  late bool status;
  late String paymentStatus;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['CustomerUid'] = customerUid;
    data['Status'] = status;
    data['PaymentStatus'] = paymentStatus;
    return data;
  }
}
