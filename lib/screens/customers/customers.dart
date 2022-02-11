import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/customer_information/customer_information.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:get/get.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key, this.isCoordinator = false}) : super(key: key);

  final bool isCoordinator;
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

  @override
  void initState() {
    _isLoading = false;
    _controller = Get.find<GeneralController>();
    _refreshController = RefreshController(initialRefresh: false);
    stableStageIndex = _controller.appState.value.bottomBarItems
        .indexWhere((element) => element.shortName == 'Постоянные');
    if (_controller.appState.value.currentIndex == stableStageIndex) {
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

    await ErrorHandler.loadingData(
        context: context, request: _controller.getRegularCustomers);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return !_isLoading
        ? Obx(
            () {
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: _refresh,
                physics: const BouncingScrollPhysics(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: widget.isCoordinator
                      ? _coordinatorCustomers(theme)
                      : _trainerCustomers(theme),
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
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
                return _customerContainer(
                  theme,
                  clientType: ClientType.coordinator,
                  customer:
                      _controller.appState.value.coordinator!.customers[index],
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
                return _customerContainer(
                  theme,
                  clientType: Enums.getClientType(
                    clientUid: _controller
                        .appState
                        .value
                        .bottomBarItems[_controller.appState.value.currentIndex]
                        .uid,
                  ),
                  customer: _controller.appState.value.sortedCustomers[
                      _controller
                          .appState
                          .value
                          .bottomBarItems[
                              _controller.appState.value.currentIndex]
                          .uid]![index],
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

  Widget _getEmptyCustomersText(ThemeData theme) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Text(
          widget.isCoordinator
              ? S.of(context).empty_customers_short
              : S.of(context).empty_customers,
          style: theme.textTheme.headline3,
        ),
      ),
    );
  }

  /// Контейнер с клиентом
  Widget _customerContainer(
    ThemeData theme, {
    required CustomerModel customer,
    required ClientType clientType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          DefaultContainer(
            isVisible: customer.isVisible,
            onTap: () {
              _controller.appState.update((model) {
                model?.currentCustomer = customer;
              });
              Get.to(
                () => CustomerInformationPage(
                  clientType: clientType,
                  isHandingButton: widget.isCoordinator,
                ),
              );
            },
            child: getContainerContent(customer, theme),
            isHighlight:
                isContainerBordered(balance: customer.paidServicesBalance),
            highlightColor: theme.colorScheme.primary.withOpacity(0.07),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget getContainerContent(CustomerModel customer, ThemeData theme) {
    /// Индекс раздела Постоянные
    if (_controller.appState.value.currentIndex == stableStageIndex) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customer.fullName,
            style: theme.textTheme.bodyText1,
          ),
          Text(
            customer.paidServicesBalance != null
                ? 'Осталось платных услуг: ${customer.paidServicesBalance}'
                : 'Осталось платных услуг: 0',
            style: theme.textTheme.headline4,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customer.fullName,
            style: theme.textTheme.bodyText1,
          ),
          Text(
            customer.birthDay,
            style: theme.textTheme.headline4,
          ),
        ],
      );
    }
  }

  bool isContainerBordered({required int? balance}) {
    ///Индекс раздела Постоянные
    var stableStageIndex = _controller.appState.value.bottomBarItems
        .indexWhere((element) => element.shortName == 'Постоянные');

    if (_controller.appState.value.currentIndex == stableStageIndex) {
      if (balance != null) {
        if (balance <= 3) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> _refresh() async {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (widget.isCoordinator) {
      await ErrorHandler.loadingData(
        context: context,
        request: _controller.getCoordinaorWorkSpace,
        repeat: false,
      );
    } else {
      if (_controller.appState.value.currentIndex != stableStageIndex) {
        await ErrorHandler.loadingData(
          context: context,
          request: _controller.getCustomers,
          repeat: false,
        );
      } else {
        await ErrorHandler.loadingData(
          context: context,
          request: _controller.getRegularCustomers,
          repeat: false,
        );
      }
    }
    _refreshController.refreshCompleted();
  }
}
