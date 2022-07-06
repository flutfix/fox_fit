import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/mocks/mocks.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:intl/intl.dart';

class HistoryContainer extends StatelessWidget {
  final History historyStats;
  final EdgeInsetsGeometry? margin;

  const HistoryContainer({
    Key? key,
    required this.historyStats,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DefaultContainer(
      padding: const EdgeInsets.fromLTRB(14, 20, 18, 15),
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                historyStats.fullName,
                style: theme.textTheme.bodyText2,
              ),
              Text(
                historyStats.service,
                style: theme.textTheme.bodyText2,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('HH:mm').format(historyStats.dataTime),
                style: theme.textTheme.headline4!.copyWith(color: Styles.blue),
              ),
              Text(
                DateFormat('dd.MM.yy').format(historyStats.dataTime),
                style: theme.textTheme.headline4!.copyWith(color: Styles.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
