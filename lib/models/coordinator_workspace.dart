import 'package:fox_fit/models/customer.dart';

class CoordinatorModel {
  CoordinatorModel({
    this.isNewNotification = false,
    this.customers = const [],
  });
  bool isNewNotification;
  List<CustomerModel> customers;
}
