import 'package:flutter/material.dart';
import 'package:fox_fit/models/month.dart';
import 'package:fox_fit/utils/picker/scroll_behavior.dart';

class Days extends StatefulWidget {
  const Days({
    Key? key,
    required this.days,
    required this.currentIndex,
    required this.onChange,
    this.width,
    this.controller,
    this.duration = 300,
  }) : super(key: key);

  final List<DaysModel> days;
  final int currentIndex;
  final Function(int) onChange;
  final ScrollController? controller;
  final double? width;
  final int duration;

  @override
  _DaysState createState() => _DaysState();
}

class _DaysState extends State<Days> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ScrollConfiguration(
      behavior: CustomBehavior(),
      child: SizedBox(
        height: 56,
        child: Stack(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              controller: widget.controller,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.days.length,
              separatorBuilder: (contex, index) => const SizedBox(width: 8),
              itemBuilder: (contex, index) {
                return _buildDays(
                  theme: theme,
                  days: widget.days[index],
                  index: index,
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.backgroundColor,
                      theme.backgroundColor.withOpacity(0.9),
                      theme.backgroundColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.backgroundColor.withOpacity(0),
                      theme.backgroundColor.withOpacity(0.9),
                      theme.backgroundColor,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDays({
    required ThemeData theme,
    required DaysModel days,
    required int index,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onChange(index);
      },
      child: AnimatedContainer(
        width: widget.width != null ? (widget.width! - 96) / 5 : null,
        duration: Duration(milliseconds: widget.duration),
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.currentIndex == index
              ? theme.focusColor
              : theme.canvasColor,
        ),
        child: Column(
          children: [
            Text(
              days.number.toString(),
              style: theme.textTheme.headline3!.copyWith(
                color: widget.currentIndex == index
                    ? theme.colorScheme.surface
                    : theme.textTheme.headline3!.color,
              ),
            ),
            // const SizedBox(height: 5),
            Text(
              days.day,
              style: theme.textTheme.headline3!.copyWith(
                color: widget.currentIndex == index
                    ? theme.colorScheme.surface
                    : theme.textTheme.headline3!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
