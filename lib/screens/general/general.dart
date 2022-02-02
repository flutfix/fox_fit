import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/screens/fresh/fresh_page.dart';
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
  late int currentIndex;
  late PageController pageController;
  @override
  void initState() {
    currentIndex = 0;
    pageController = PageController(initialPage: currentIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GeneralController controller = Get.put(GeneralController());
    ThemeData theme = Theme.of(context);

    return Obx(() {
      if (!controller.appState.value.isLoading) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: const CustomAppBar(
            title: 'Новые',
            count: 5,
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const [
              /// Страница [Новые]
              KeepAlivePage(child: FreshPage()),
            ],
          ),
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
    });
  }

  void setPage(int index) {
    currentIndex = index;
    pageController.jumpToPage(
      index,
    );
  }

}
