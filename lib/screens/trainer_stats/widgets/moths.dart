import 'package:flutter/material.dart';
import 'package:fox_fit/models/trainer_stats.dart';

class Months extends StatefulWidget {
  const Months({
    Key? key,
    required this.width,
    required this.items,
    required this.currentIndex,
    required this.onChange,
    this.duration = 300,
  }) : super(key: key);

  final double width;
  final int duration;
  final List<TrainerPerfomanceModel> items;
  final Function(int) onChange;
  final int currentIndex;

  @override
  _MonthsState createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.items.length,
        (index) => _buildMonth(
          theme,
          text: widget.items[index].month,
          isActive: widget.items[index].isActive,
          index: index,
        ),
      ),
    );
  }

  Widget _buildMonth(
    ThemeData theme, {
    required String text,
    required bool isActive,
    required int index,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onChange(index);
      },
      child: AnimatedContainer(
        width: (widget.width - 54) / 3,
        duration: Duration(milliseconds: widget.duration),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: !isActive ? theme.backgroundColor : theme.focusColor,
          border: Border.all(width: 2, color: theme.focusColor),
        ),
        child: Text(
          text,
          style: theme.textTheme.headline6!.copyWith(
              color: !isActive ? theme.focusColor : theme.colorScheme.surface),
        ),
      ),
    );
  }
}
