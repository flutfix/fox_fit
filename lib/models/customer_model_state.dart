import 'package:fox_fit/models/customer.dart';

class CustomerModelState {
  CustomerModelState({
    required this.model,
    required this.arrivalStatus,
  });

  final CustomerModel model;
  bool arrivalStatus;
}
