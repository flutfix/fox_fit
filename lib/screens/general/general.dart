import 'package:flutter/material.dart';
import 'package:fox_fit/config/images.dart';
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
    ThemeData theme = Theme.of(context);
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
          /// Page [Новые]
          KeepAlivePage(child: FreshPage()),

          ///Page [Назначено]
          KeepAlivePage(child: AssignedPage()),

          ///Page [Проведено]
          KeepAlivePage(child: PerfomedPage()),

          ///Page [Постоянные]
          KeepAlivePage(child: StablePage()),

          ///Page [Ещё]
          KeepAlivePage(child: StillPage()),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        items: getBottomBarItems(theme),
        onChange: (index) {
          setState(() {
            setPage(index);
          });
        },
      ),
    );
  }

  setPage(int index) {
    currentIndex = index;
    pageController.jumpToPage(
      index,
    );
  }

  List<ItemBottomBar> getBottomBarItems(ThemeData theme) {
    return [
      ItemBottomBar(
        icon: Images.fresh,
        name: S.of(context).fresh,
        activeColor: theme.hintColor,
        inactiveColor: theme.hoverColor,
      ),
      ItemBottomBar(
        icon: Images.assigned,
        name: S.of(context).assigned,
        activeColor: theme.hintColor,
        inactiveColor: theme.hoverColor,
      ),
      ItemBottomBar(
        icon: Images.perfomed,
        name: S.of(context).perfomed,
        activeColor: theme.hintColor,
        inactiveColor: theme.hoverColor,
      ),
      ItemBottomBar(
        icon: Images.stable,
        name: S.of(context).stable,
        activeColor: theme.hintColor,
        inactiveColor: theme.hoverColor,
      ),
      ItemBottomBar(
        icon: Images.still,
        name: S.of(context).still,
        activeColor: theme.hintColor,
        inactiveColor: theme.hoverColor,
      ),
    ];
  }
}
