import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/customers/widgets/customer_coontainer.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:get/get.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({
    Key? key,
    this.pageType = CustomersPageType.general,
  }) : super(key: key);

  final CustomersPageType pageType;

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late bool _isLoading;
  late GeneralController _controller;
  late RefreshController _refreshController;
  late int stableStageIndex;
  late bool isStableCustomersPage;
  late bool _canVibrate;
  late CustomersPageType pageType;

  @override
  void initState() {
    _isLoading = false;
    _controller = Get.find<GeneralController>();
    _refreshController = RefreshController(initialRefresh: false);
    pageType = widget.pageType;
    stableStageIndex = _controller.appState.value.bottomBarItems
        .indexWhere((element) => element.shortName == 'Постоянные');
    if (_controller.appState.value.currentIndex == stableStageIndex) {
      pageType = CustomersPageType.stable;
      loadStableCustomers();
    }
    _canVibrate = _controller.appState.value.isCanVibrate;
    super.initState();
  }

  /// [Get] Постоянные клиенты
  Future<dynamic> loadStableCustomers() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: _controller.getRegularCustomers,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return (!_isLoading)
        ? Obx(
            () {
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: _refresh,
                physics: const BouncingScrollPhysics(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _pageType(theme),
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  /// Отрисовка списка клиентов под тип страницы
  Widget _pageType(ThemeData theme) {
    switch (pageType) {

      /// Клиенты из воронки тренера BottomBar
      case CustomersPageType.general:
        return _trainerCustomers(theme);

      /// Постоянные клиенты
      case CustomersPageType.stable:
        return _stableCustomers(theme);

      /// Координатор
      case CustomersPageType.coordinator:
        return _coordinatorCustomers(theme);

      /// Спящие клиенты
      case CustomersPageType.sleep:
        return _inactiveCustomers(theme);
      default:
        return _trainerCustomers(theme);
    }
  }

  /// Колонка клиентов для тренера [Разделы BottomBar]
  Widget _trainerCustomers(ThemeData theme) {
    if (_controller.appState.value.sortedCustomers[_controller.appState.value
            .bottomBarItems[_controller.appState.value.currentIndex].uid] !=
        null) {
      if (_controller
          .appState
          .value
          .sortedCustomers[_controller.appState.value
              .bottomBarItems[_controller.appState.value.currentIndex].uid]!
          .isNotEmpty) {
        return Column(
          children: [
            const SizedBox(height: 25),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _controller
                  .appState
                  .value
                  .sortedCustomers[_controller
                      .appState
                      .value
                      .bottomBarItems[_controller.appState.value.currentIndex]
                      .uid]!
                  .length,
              itemBuilder: (context, index) {
                return CustomerContainer(
                  customer: _controller.appState.value.sortedCustomers[
                      _controller
                          .appState
                          .value
                          .bottomBarItems[
                              _controller.appState.value.currentIndex]
                          .uid]![index],
                  clientType: Enums.getClientType(
                    clientUid: _controller
                        .appState
                        .value
                        .bottomBarItems[_controller.appState.value.currentIndex]
                        .uid,
                  ),
                );
              },
            ),
            const SizedBox(height: 19),
          ],
        );
      } else {
        return _getEmptyCustomersText(theme);
      }
    } else {
      return _getEmptyCustomersText(theme);
    }
  }

  Widget _stableCustomers(ThemeData theme) {
    if (_controller.appState.value.sortedCustomers[Client.permanent] != null) {
      if (_controller
          .appState.value.sortedCustomers[Client.permanent]!.isNotEmpty) {
        // Сортировка клиентов в алфавитном порядке
        List<CustomerModel> permanentCustomers = _controller.sortAlphabetically(
            customers:
                _controller.appState.value.sortedCustomers[Client.permanent]!);

        return Column(
          children: [
            const SizedBox(height: 25),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: permanentCustomers.length,
              itemBuilder: (context, index) {
                return CustomerContainer(
                  widgetType: CustomerContainerType.balance,
                  customer: permanentCustomers[index],
                  clientType: Enums.getClientType(
                    clientUid: _controller
                        .appState
                        .value
                        .bottomBarItems[_controller.appState.value.currentIndex]
                        .uid,
                  ),
                );
              },
            ),
            const SizedBox(height: 19),
          ],
        );
      } else {
        return _getEmptyCustomersText(theme);
      }
    } else {
      return _getEmptyCustomersText(theme);
    }
  }

  /// Колонка клиентов для координатора
  Widget _coordinatorCustomers(ThemeData theme) {
    if (_controller.appState.value.coordinator != null) {
      if (_controller.appState.value.coordinator!.customers.isNotEmpty) {
        return Column(
          children: [
            const SizedBox(height: 25),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  _controller.appState.value.coordinator!.customers.length,
              itemBuilder: (context, index) {
                return CustomerContainer(
                    customer: _controller
                        .appState.value.coordinator!.customers[index],
                    clientType: ClientType.coordinator);
              },
            ),
            const SizedBox(height: 19),
          ],
        );
      } else {
        return _getEmptyCustomersText(theme);
      }
    } else {
      return _getEmptyCustomersText(theme);
    }
  }

  /// Колонка спящих клиентов
  Widget _inactiveCustomers(ThemeData theme) {
    if (_controller.appState.value.inactiveCustomers.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(height: 25),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _controller.appState.value.inactiveCustomers.length,
            itemBuilder: (context, index) {
              return CustomerContainer(
                customer: _controller.appState.value.inactiveCustomers[index],
                clientType: ClientType.sleeping,
              );
            },
          ),
          const SizedBox(height: 19),
        ],
      );
    } else {
      return _getEmptyCustomersText(theme);
    }
  }

  Widget _getEmptyCustomersText(ThemeData theme) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Text(
          _isShortText(),
          style: theme.textTheme.headline3,
        ),
      ),
    );
  }

  String _isShortText() {
    if (pageType == CustomersPageType.general ||
        pageType == CustomersPageType.stable) {
      return S.of(context).empty_customers;
    }
    return S.of(context).empty_customers_short;
  }

  /// Pull to Refresh
  Future<void> _refresh() async {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (pageType == CustomersPageType.coordinator) {
      await ErrorHandler.request(
        context: context,
        request: _controller.getCoordinaorWorkSpace,
        repeat: false,
      );
    } else if (pageType == CustomersPageType.sleep) {
      await ErrorHandler.request(
        context: context,
        request: _controller.getInactiveCustomers,
        repeat: false,
      );
    } else {
      if (_controller.appState.value.currentIndex != stableStageIndex) {
        await ErrorHandler.request(
          context: context,
          request: _controller.getCustomers,
          repeat: false,
        );
      } else {
        await ErrorHandler.request(
          context: context,
          request: _controller.getRegularCustomers,
          repeat: false,
        );
      }
    }
    _refreshController.refreshCompleted();
  }
}
