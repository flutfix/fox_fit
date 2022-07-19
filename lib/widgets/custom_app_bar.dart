import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/widgets/badge.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.height = 126,
    required this.title,
    this.isNotification = true,
    this.onNotification,
    this.isBackArrow = false,
    this.onBack,
    this.count,
    this.countNotifications = 0,
    this.action,
  }) : super(key: key);

  final double height;
  final String title;
  final bool isNotification;
  final Function()? onNotification;
  final bool isBackArrow;
  final Function()? onBack;
  final int? count;
  final int countNotifications;
  final Widget? action;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late GeneralController _controller;
  @override
  void initState() {
    _controller = Get.find<GeneralController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: widget.height,
      width: width,
      padding: const EdgeInsets.fromLTRB(20, 25, 14, 25),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.isBackArrow)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.onBack,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset(
                          Images.backArrow,
                          width: 10,
                        ),
                        const SizedBox(
                          width: 22,
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                if (widget.count != null)
                  Text(
                    '${widget.title} (${widget.count})',
                    style: theme.textTheme.headline1,
                  )
                else
                  Text(
                    widget.title,
                    style: theme.textTheme.headline1,
                  )
              ],
            ),
            widget.isNotification
                ? Obx(
                    () => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.onNotification,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            Images.notifications,
                            width: 18.88,
                            color: _controller
                                        .appState.value.countNewNotifications !=
                                    0
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                          if (widget.countNotifications != 0)
                            Badge(
                              countNotifications: widget.countNotifications,
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 12),
                            ),
                          const SizedBox(
                            width: 36,
                            height: 36,
                          )
                        ],
                      ),
                    ),
                  )
                : widget.action ??
                    const SizedBox(
                      width: 36,
                    )
          ],
        ),
      ),
    );
  }
}
