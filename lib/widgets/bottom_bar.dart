import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';
import 'package:get/get.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    Key? key,
    required this.items,
    required this.onChange,
    required this.activeColor,
    required this.inActiveColor,
    this.textColor,
    this.lineColor,
    this.verticalPadding = 14.5,
    this.duration = 150,
  }) : super(key: key);

  final List<ItemBottomBarModel> items;
  final Function(int) onChange;
  final double verticalPadding;
  final int duration;
  final Color activeColor;
  final Color inActiveColor;
  final Color? textColor;
  final Color? lineColor;

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late GeneralController controller;

  @override
  void initState() {
    controller = Get.find<GeneralController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Container(
            padding: getPadding(),
            width: width,
            alignment: Alignment.center,
            height: getHeight,
            color: theme.canvasColor,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.items.length,
                  (index) {
                    var item = widget.items[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.onChange(index);
                      },
                      child: SizedBox(
                        width: (width - 40) / widget.items.length,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              getIcon(index),
                              width: 20,
                              color: index ==
                                      controller.appState.value.currentIndex
                                  ? widget.activeColor
                                  : widget.inActiveColor,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.shortName,
                              style: theme.textTheme.caption!.copyWith(
                                color: index ==
                                        controller.appState.value.currentIndex
                                    ? widget.activeColor
                                    : widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AnimatedPadding(
            padding: EdgeInsets.only(left: getAnimatedPaddding),
            child: Container(
              width: (width - 40) / widget.items.length,
              height: 2,
              decoration: BoxDecoration(
                  color: widget.lineColor ?? theme.hintColor,
                  borderRadius: BorderRadius.circular(1)),
            ),
            duration: Duration(milliseconds: widget.duration),
          ),
        )
      ],
    );
  }

  EdgeInsetsGeometry getPadding() {
    // if (Platform.isIOS) {
    //   return const EdgeInsets.fromLTRB(20, 14, 20, 20);
    // } else {
    return EdgeInsets.symmetric(
        horizontal: 20, vertical: widget.verticalPadding);
    // }
  }

  double get getHeight {
    // if (Platform.isIOS) {
    //   return 72;
    // } else {
    return (widget.verticalPadding * 2) + 38;
    // }
  }

  double get getAnimatedPaddding =>
      controller.appState.value.currentIndex *
      (MediaQuery.of(context).size.width - 40) /
      widget.items.length;

  String getIcon(int index) {
    switch (index) {
      case 0:
        return Images.fresh;
      case 1:
        return Images.assigned;
      case 2:
        return Images.perfomed;
      case 3:
        return Images.stable;
      case 4:
        return Images.still;
      default:
        return Images.fresh;
    }
  }
}
