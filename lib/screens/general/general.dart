import 'package:flutter/material.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:fox_fit/screens/assigned/assigned_page.dart';
import 'package:fox_fit/screens/fresh/fresh_page.dart';
import 'package:fox_fit/screens/perfomed/perfomed_page.dart';
import 'package:fox_fit/screens/stable/stable_page.dart';
import 'package:fox_fit/screens/still/still_page.dart';
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

              ///Страница [Назначено]
              KeepAlivePage(child: AssignedPage()),

              ///Страница [Проведено]
              KeepAlivePage(child: PerfomedPage()),

              ///Страница [Постоянные]
              KeepAlivePage(child: StablePage()),

              ///Страница [Ещё]
              KeepAlivePage(child: StillPage()),
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

  setPage(int index) {
    currentIndex = index;
    pageController.jumpToPage(
      index,
    );
  }

  List<ItemBottomBarModel> getBottomBarItems(ThemeData theme) {
    return [];
  }
}
