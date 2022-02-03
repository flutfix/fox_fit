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
  @override
  Widget build(BuildContext context) {
    final GeneralController controller = Get.put(GeneralController());
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.isBackArrow)
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.onBack,
                      child: SvgPicture.asset(Images.backArrow)),
                const SizedBox(width: 9),
                if (widget.count != null)
                  Text(
                    '${widget.title}(${widget.count})',
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
                child: SvgPicture.asset(
                  Images.notifications,
                  width: 24,
                  color: controller.appState.value.isNewNotifications ? theme.colorScheme.primary : theme.iconTheme.color,
                ))
          ],
        ),
      ),
    );
  }
}
