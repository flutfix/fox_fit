import 'package:flutter/material.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/customers/customers.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class SleepingCustomersPage extends StatefulWidget {
  const SleepingCustomersPage({Key? key}) : super(key: key);

  @override
  _SleepingCustomersPageState createState() => _SleepingCustomersPageState();
}

class _SleepingCustomersPageState extends State<SleepingCustomersPage> {
  late bool _isLoading;
  late GeneralController _controller;

  @override
  void initState() {
    _isLoading = false;
    _controller = Get.find<GeneralController>();
    _loadCustomers();
    super.initState();
  }

  Future<dynamic> _loadCustomers() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.loadingData(
      context: context,
      request: () {
        return _controller.getInactiveCustomers();
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Swipe(
      onSwipeRight: () => Get.back(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: _appBar(),
        body: !_isLoading
            ? const CustomersPage(
                pageType: CustomersPageType.sleep,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  CustomAppBar _appBar() {
    return CustomAppBar(
      title: S.of(context).sleeping_customers,
      isBackArrow: true,
      onBack: () async {
        Get.back();
        await ErrorHandler.singleRequest(
          context: context,
          request: _controller.getCustomers,
          skipCheck: true,
          handler: (_) {
            CustomSnackbar.getSnackbar(
              title: S.of(context).no_internet_access,
              message: S.of(context).failed_update_list,
            );
          },
        );
      },
      onNotification: () {
        Get.toNamed(Routes.notifications);
      },
    );
  }
}
