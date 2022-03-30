import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/models/animation.dart';
import 'package:fox_fit/utils/enums.dart';

class CustomAnimatedContainer extends StatefulWidget {
  const CustomAnimatedContainer({
    Key? key,
    required this.text,
    required this.onTap,
    this.isButtonDelete = false,
    this.onDelete,
    this.animation,
    this.isActive = true,
    this.arrivalStatus = false,
    this.wrapText = true,
    this.paymentStatusType,
  }) : super(key: key);

  final String text;
  final Function() onTap;
  final bool isButtonDelete;
  final Function()? onDelete;
  final PaymentStatusType? paymentStatusType;
  final AnimationModel? animation;
  final bool isActive;
  final bool arrivalStatus;
  final bool wrapText;

  @override
  _CustomAnimatedContainerState createState() =>
      _CustomAnimatedContainerState();
}

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animation?.duration ?? 0),
        curve: Curves.easeOut,
        width: (widget.isActive)
            ? widget.animation?.activeWidth
            : widget.animation?.inactiveWidth,
        height: (widget.isActive)
            ? widget.animation?.activeHeight
            : widget.animation?.inactiveHeight,
        padding: (widget.animation != null)
            ? const EdgeInsets.symmetric(vertical: 14, horizontal: 11)
            : const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          border: (widget.animation != null)
              ? (widget.isActive)
                  ? Border.all(color: theme.colorScheme.secondary)
                  : null
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(widget.paymentStatusType != null)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: widget.paymentStatusType == PaymentStatusType.doneAndPayed
                        ? Styles.green
                        : widget.paymentStatusType == PaymentStatusType.plannedAndPayed
                            ? Styles.yellow
                            : Styles.red,
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: (widget.wrapText)
                      ? MediaQuery.of(context).size.width - 140
                      : null,
                  child: AnimatedDefaultTextStyle(
                    child: Text(widget.text),
                    style: (widget.isActive)
                        ? theme.textTheme.bodyText1!
                        : theme.textTheme.bodyText1!.copyWith(fontSize: 12),
                    duration:
                        Duration(milliseconds: widget.animation?.duration ?? 0),
                    curve: Curves.easeOut,
                  ),
                ),
              ],
            ),
            if (widget.isButtonDelete)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (widget.onDelete != null) {
                    widget.onDelete!();
                  }
                },
                child: SvgPicture.asset(
                  Images.cross,
                  width: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
