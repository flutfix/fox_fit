import 'package:fox_fit/models/customer.dart';

class CustomerModelState {
  CustomerModelState({
    required this.model,
    required this.arrivalStatus,
    this.isCanceled = false,
  });

  final CustomerModel model;
  bool arrivalStatus;
  bool isCanceled;
}
