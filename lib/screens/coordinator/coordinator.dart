import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/customers/customers.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class CoordinatorPage extends StatefulWidget {
  const CoordinatorPage({Key? key}) : super(key: key);

  @override
  _CoordinatorPageState createState() => _CoordinatorPageState();
}

class _CoordinatorPageState extends State<CoordinatorPage> {
  late GeneralController _controller;
  late bool _isLoading;
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
    await _controller.getCoordinaorWorkSpace();
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
        appBar: _appBar(_controller),
        body: !_isLoading
            ? const CustomersPage(
                isCoordinator: true,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  CustomAppBar _appBar(GeneralController controller) {
    return CustomAppBar(
      title: S.of(context).coordinaor_workspace,
      isBackArrow: true,
      onBack: () {
        Get.back();
      },
      onNotification: () {},
    );
  }
}
