import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.height = 126,
    required this.title,
    this.onTap,
    this.isBackArrow = false,
    this.onBack,
    this.count,
  }) : super(key: key);

  final double height;
  final String title;
  final Function()? onTap;
  final bool isBackArrow;
  final Function()? onBack;
  final int? count;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late GeneralController controller;
  @override
  void initState() {
    controller = Get.put(GeneralController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: widget.height,
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
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
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.onTap,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  SvgPicture.asset(
                    Images.notifications,
                    width: 24,
                    color: controller.appState.value.isNewNotifications
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color,
                  ),
                  const SizedBox(
                    width: 36,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
