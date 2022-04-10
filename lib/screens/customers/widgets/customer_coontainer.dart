import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/customer_information/customer_information.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';

class CustomerContainer extends StatefulWidget {
  const CustomerContainer({
    Key? key,
    required this.customer,
    required this.clientType,
    this.widgetType,
    this.onTap,
  }) : super(key: key);

  final CustomerModel customer;
  final ClientType clientType;
  final CustomerContainerType? widgetType;
  final Function()? onTap;

  @override
  State<CustomerContainer> createState() => _CustomerContainerState();
}

class _CustomerContainerState extends State<CustomerContainer> {
  late GeneralController _controller;
  late CustomerContainerType widgetType;
  @override
  void initState() {
    widgetType = widget.widgetType ?? CustomerContainerType.birthDate;

    _controller = Get.find<GeneralController>();
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
              if (widget.onTap != null) {
                widget.onTap!();
              } else {
                Get.to(
                  () => CustomerInformationPage(
                    clientType: widget.clientType,
                    isHandingButton: _isHandlingButton(widget.clientType),
                  ),
                  transition: Transition.fadeIn,
                );
              }
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
    /// Подсвечиваться может только контейнер отображающий баланс
    if (widgetType == CustomerContainerType.balance) {
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
    /// Отрисовка контента по типу виджета с клиентом
    if (widgetType == CustomerContainerType.balance) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: _constaintsWidth(customer.isBirthday)),
                child: Text(
                  customer.fullName,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              Text(
                customer.paidServicesBalance != null
                    ? 'Осталось платных услуг: ${customer.paidServicesBalance}'
                    : 'Осталось платных услуг: 0',
                style: theme.textTheme.headline4,
              ),
            ],
          ),
          customer.isBirthday
              ? SvgPicture.asset(Images.cake)
              : const SizedBox(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: _constaintsWidth(customer.isBirthday)),
                child: Text(
                  customer.fullName,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              Text(
                customer.birthDay,
                style: theme.textTheme.headline4,
              ),
            ],
          ),
          customer.isBirthday
              ? SvgPicture.asset(Images.cake)
              : const SizedBox(),
        ],
      );
    }
  }

  /// Если у человека др, то места под текст меньше
  double _constaintsWidth(bool isBirthday) {
    if (isBirthday) {
      return MediaQuery.of(context).size.width * 0.7;
    } else {
      return MediaQuery.of(context).size.width - 70;
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
