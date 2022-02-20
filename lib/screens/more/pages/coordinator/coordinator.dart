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

class CoordinatorPage extends StatefulWidget {
  const CoordinatorPage({Key? key}) : super(key: key);

  @override
  _CoordinatorPageState createState() => _CoordinatorPageState();
}

class _CoordinatorPageState extends State<CoordinatorPage> {
  late bool _isLoading;
  late GeneralController _controller;

  @override
  void initState() {
    _isLoading = false;
    _controller = Get.find<GeneralController>();
    _loadCoordinaorWorkSpace();
    super.initState();
  }

  Future<dynamic> _loadCoordinaorWorkSpace() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: _controller.getCoordinaorWorkSpace,
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
                pageType: CustomersPageType.coordinator,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  CustomAppBar _appBar() {
    return CustomAppBar(
      title: S.of(context).coordinator,
      isBackArrow: true,
      onBack: () async {
        Get.back();
        await ErrorHandler.request(
          context: context,
          request: _controller.getCustomers,
          skipCheck: true,
          handler: (_) async {
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
