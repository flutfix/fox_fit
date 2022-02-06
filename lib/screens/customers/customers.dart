import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/customer_information/customer_information.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:get/get.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late GeneralController controller;
  late RefreshController _refreshController;
  late bool isStableCustomersPage;
  late int stableStageIndex;
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = false;
    controller = Get.find<GeneralController>();
    _refreshController = RefreshController(initialRefresh: false);
    stableStageIndex = controller.appState.value.bottomBarItems
        .indexWhere((element) => element.shortName == 'Постоянные');
    if (controller.appState.value.currentIndex == stableStageIndex) {
      loadStableCustomers();
    }
    super.initState();
  }

  Future<dynamic> loadStableCustomers() async {
    setState(() {
      _isLoading = true;
    });
    await controller.getRegularCustomers();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return !_isLoading
        ? SmartRefresher(
            controller: _refreshController,
            onRefresh: _refresh,
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Obx(
                () => Column(
                  children: [
                    const SizedBox(height: 25),
                    if (controller.appState.value.sortedCustomers[controller
                            .appState
                            .value
                            .bottomBarItems[
                                controller.appState.value.currentIndex]
                            .uid] !=
                        null)
                      ...List.generate(
                          controller
                              .appState
                              .value
                              .sortedCustomers[controller
                                  .appState
                                  .value
                                  .bottomBarItems[
                                      controller.appState.value.currentIndex]
                                  .uid]!
                              .length, (index) {
                        var customer =
                            controller.appState.value.sortedCustomers[controller
                                .appState
                                .value
                                .bottomBarItems[
                                    controller.appState.value.currentIndex]
                                .uid]![index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              DefaultContainer(
                                isVisible: customer.isVisible,
                                onTap: () {
                                  Get.to(
                                    () => CustomerInformationPage(
                                      customer: customer,
                                    ),
                                  );
                                },
                                child: getContainerContent(customer, theme),
                                isHighlight: isContainerBordered(
                                    balance: customer.paidServicesBalance),
                                highlightColor:
                                    theme.colorScheme.primary.withOpacity(0.07),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                        );
                      }),
                    const SizedBox(height: 19),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget getContainerContent(CustomerModel customer, ThemeData theme) {
    ///Индекс раздела Постоянные

    if (controller.appState.value.currentIndex == stableStageIndex) {
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
    var stableStageIndex = controller.appState.value.bottomBarItems
        .indexWhere((element) => element.shortName == 'Постоянные');

    if (controller.appState.value.currentIndex == stableStageIndex) {
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
    await Future.delayed(const Duration(seconds: 1));
  }
}
