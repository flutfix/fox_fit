import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';

class AppStateModel {
  AppStateModel({
    this.isLoading = false,
    this.customers = const [],
    this.bottomBarItems = const [],
  });
  bool isLoading;
  List<CustomerModel> customers;
  List<ItemBottomBarModel> bottomBarItems;
}
