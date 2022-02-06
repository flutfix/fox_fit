import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/screens/customers/customers.dart';
import 'package:fox_fit/screens/more/more.dart';
import 'package:fox_fit/widgets/bottom_bar.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/keep_alive_page.dart';
import 'package:get/get.dart';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);

  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  late GeneralController controller;
  late PageController pageController;

  @override
  void initState() {
    controller = Get.put(GeneralController());
    var authData = Get.arguments;
    controller.appState.update((model) {
      model?.auth = authData;
    });
    getCustomers();
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  Future<void> getCustomers() async {
    controller.appState.update((model) {
      model?.isLoading = true;
    });
    await controller.getCustomers();

    controller.appState.update((model) {
      model?.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Obx(
      () {
        if (!controller.appState.value.isLoading) {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: appBar(controller),
            body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  ...List.generate(
                    controller.appState.value.bottomBarItems.length - 1,
                    (index) {
                      return const KeepAlivePage(child: CustomersPage());
                    },
                  ),
                  const MorePage(),
                ]),
            bottomNavigationBar: Obx(
              () => CustomBottomBar(
                items: controller.appState.value.bottomBarItems,
                activeColor: theme.hintColor,
                inActiveColor: theme.hoverColor,
                onChange: (index) {
                  setState(() {
                    setPage(index);
                  });
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 4,
              ),
            ),
          );
        }
      },
    );
  }

  CustomAppBar appBar(GeneralController controller) {
    var customers = controller.appState.value.sortedCustomers[controller
        .appState
        .value
        .bottomBarItems[controller.appState.value.currentIndex]
        .uid];
    return CustomAppBar(
      title: controller.appState.value
          .bottomBarItems[controller.appState.value.currentIndex].shortName,
      count: (customers != null) ? customers.length : null,
      onTap: () {
      },
    );
  }

  void setPage(int index) {
    Get.find<GeneralController>().appState.update((model) {
      model?.currentIndex = index;
    });
    pageController.jumpToPage(
      index,
    );
  }
}
