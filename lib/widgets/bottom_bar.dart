import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/models/item_bottom_bar.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    Key? key,
    required this.items,
    required this.onChange,
    this.verticalPadding = 14.0,
    this.duration = 150,
  }) : super(key: key);

  final List<ItemBottomBar> items;
  final Function(int) onChange;
  final double verticalPadding;
  final int duration;

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = 0;
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
                      setState(() {
                        currentIndex = index;
                      });
                      widget.onChange(currentIndex);
                    },
                    child: SizedBox(
                      width: (width - 40) / widget.items.length,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            item.icon,
                            width: 20,
                            color: index == currentIndex
                                ? item.activeColor
                                : item.inactiveColor,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.name,
                            style: theme.textTheme.caption!.copyWith(
                                color: index == currentIndex
                                    ? item.activeColor
                                    : item.inactiveColor),
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
      currentIndex *
      (MediaQuery.of(context).size.width - 40) /
      widget.items.length;
}