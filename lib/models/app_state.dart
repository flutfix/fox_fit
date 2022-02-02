import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';

class AppStateModel {
  AppStateModel({
    this.isLoading = false,
    this.currentIndex = 0,
    this.isNewNotifications = false,
    this.customers = const [],
    this.bottomBarItems = const [],
    this.sortedCustomers = const {},
  });
  bool isLoading;
  int currentIndex;
  bool isNewNotifications;

  ///Все клиенты
  List<CustomerModel> customers;

  ///Разделы Bottom Bar
  List<ItemBottomBarModel> bottomBarItems;

  ///Отсортированные клиенты по разделам BottomBar, где ключ [Uid] раздела
  Map<String, List<CustomerModel>> sortedCustomers;
}
