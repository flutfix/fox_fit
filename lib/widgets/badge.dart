import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';

class Badge extends StatefulWidget {
  final int countNotifications;
  final EdgeInsetsGeometry? margin;

  const Badge({
    Key? key,
    required this.countNotifications,
    this.margin,
  }) : super(key: key);

  @override
  State<Badge> createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(1),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(90),
      ),
      child: Container(
        width: 12,
        height: 12,
        padding: const EdgeInsets.only(top: 0.5),
        decoration: BoxDecoration(
          color: theme.toggleableActiveColor,
          borderRadius: BorderRadius.circular(90),
        ),
        child: Text(
          widget.countNotifications.toString(),
          textAlign: TextAlign.center,
          style: theme.textTheme.subtitle2!.copyWith(
            fontWeight: FontWeight.w600,
            color: Styles.white,
            fontSize: 7.5,
          ),
        ),
      ),
    );
  }
}
