import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/models/trainer_stats.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:intl/intl.dart';

class HistoryContainer extends StatelessWidget {
  final HistoryStats history;
  final EdgeInsetsGeometry? margin;

  const HistoryContainer({
    Key? key,
    required this.history,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return DefaultContainer(
      padding: const EdgeInsets.fromLTRB(14, 20, 18, 15),
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width - 128,
                child: Text(
                  history.customer,
                  style: theme.textTheme.bodyText2,
                ),
              ),
              Text(
                history.service,
                style: theme.textTheme.bodyText2,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('HH:mm').format(history.time),
                style: theme.textTheme.headline4!.copyWith(color: Styles.blue),
              ),
              Text(
                DateFormat('dd.MM.yy').format(history.date),
                style: theme.textTheme.headline4!.copyWith(color: Styles.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
