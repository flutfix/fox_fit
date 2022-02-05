import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/images.dart';
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
    this.verticalPadding = 14.0,
    this.duration = 150,
  }) : super(key: key);

  final List<ItemBottomBarModel> items;
  final Function(int) onChange;
  final double verticalPadding;
  final int duration;
  final Color activeColor;
  final Color inActiveColor;

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
            padding: EdgeInsets.symmetric(
                horizontal: 20.0, vertical: widget.verticalPadding),
            width: width,
            alignment: Alignment.center,
            height: getHeight,
            color: theme.canvasColor,
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
                            color: index == controller.appState.value.currentIndex
                                ? widget.activeColor
                                : widget.inActiveColor,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.shortName,
                            style: theme.textTheme.caption!.copyWith(
                                color: index == controller.appState.value.currentIndex
                                    ? widget.activeColor
                                    : widget.inActiveColor),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AnimatedPadding(
            padding: EdgeInsets.only(left: getAnimatedPaddding),
            child: Container(
              width: (width - 40) / widget.items.length,
              height: 2,
              decoration: BoxDecoration(
                  color: theme.hintColor,
                  borderRadius: BorderRadius.circular(1)),
            ),
            duration: Duration(milliseconds: widget.duration),
          ),
        )
      ],
    );
  }

  double get getHeight => (widget.verticalPadding * 2) + 38;

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
