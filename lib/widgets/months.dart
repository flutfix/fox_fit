import 'package:flutter/material.dart';
import 'package:fox_fit/utils/behavior.dart';

class Months extends StatefulWidget {
  const Months({
    Key? key,
    required this.months,
    required this.currentIndex,
    required this.onChange,
    this.controller,
    this.width,
    this.duration = 300,
    this.attenuation = false,
  }) : super(key: key);

  final List<String> months;
  final int currentIndex;
  final Function(int) onChange;
  final ScrollController? controller;
  final double? width;
  final int duration;
  final bool attenuation;

  @override
  _MonthsState createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ScrollConfiguration(
      behavior: CustomBehavior(),
      child: SizedBox(
        height: 38,
        child: Stack(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              controller: widget.controller,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.months.length,
              separatorBuilder: (contex, index) => const SizedBox(width: 5),
              itemBuilder: (contex, index) {
                return _buildMonth(
                  theme: theme,
                  month: widget.months[index],
                  index: index,
                );
              },
            ),
            if (widget.attenuation)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 25,
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
            if (widget.attenuation)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 25,
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

  Widget _buildMonth({
    required ThemeData theme,
    required String month,
    required int index,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onChange(index);
      },
      child: AnimatedContainer(
        width: widget.width != null ? (widget.width! - 50) / 3 : null,
        duration: Duration(milliseconds: widget.duration),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: widget.currentIndex == index
              ? theme.focusColor
              : theme.backgroundColor,
          border: Border.all(width: 2, color: theme.focusColor),
        ),
        child: Text(
          month,
          style: theme.textTheme.headline6!.copyWith(
            color: widget.currentIndex == index
                ? theme.colorScheme.surface
                : theme.focusColor,
          ),
        ),
      ),
    );
  }
}
