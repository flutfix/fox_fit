import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';

import '../../customer_information/customer_information.dart';

class CustomerContainer extends StatefulWidget {
  const CustomerContainer({
    Key? key,
    required this.customer,
    required this.clientType,
  }) : super(key: key);

  final CustomerModel customer;
  final ClientType clientType;

  @override
  State<CustomerContainer> createState() => _CustomerContainerState();
}

class _CustomerContainerState extends State<CustomerContainer> {
  late GeneralController _controller;
  late int stableStageIndex;
  @override
  void initState() {
    _controller = Get.find<GeneralController>();
    stableStageIndex = _controller.appState.value.bottomBarItems
        .indexWhere((element) => element.shortName == 'Постоянные');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          DefaultContainer(
            isVisible: widget.customer.isVisible,
            onTap: () {
              _controller.appState.update((model) {
                model?.currentCustomer = widget.customer;
              });
              Get.to(
                () => CustomerInformationPage(
                  clientType: widget.clientType,
                  isHandingButton: _isHandlingButton(widget.clientType),
                ),
              );
            },
            child: getContainerContent(widget.customer, theme),
            isHighlight: isContainerBordered(
                balance: widget.customer.paidServicesBalance),
            highlightColor: theme.colorScheme.primary.withOpacity(0.07),
          ),
          const SizedBox(height: 6)
        ],
      ),
    );
  }

  bool isContainerBordered({required int? balance}) {
    /// Индекс раздела Постоянные

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

  bool _isHandlingButton(ClientType type) {
    switch (type) {
      case ClientType.coordinator:
        return true;
      default:
    }
    return false;
  }
}