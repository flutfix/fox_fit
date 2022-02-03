import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/widgets/default_container.dart';

class StatsCard extends StatefulWidget {
  const StatsCard(
      {Key? key,
      required this.sales,
      required this.plan,
      required this.progress,
      this.duration = 200})
      : super(key: key);

  final String sales;
  final String plan;
  final String progress;
  final int duration;

  @override
  _StatsCardState createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double progressContainerWidth = MediaQuery.of(context).size.width - 70;

    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            theme,
            text: 'Всего продаж',
            count: widget.sales,
          ),
          _buildRow(
            theme,
            text: 'План',
            count: widget.plan,
          ),
          const SizedBox(height: 4),
          Text(
            'Выполнение плана ${double.parse(widget.progress) * 100}%',
            style: theme.textTheme.headline3!.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: widget.duration),
                width: progressContainerWidth * double.parse(widget.progress),
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(ThemeData theme,
      {required String text, required String count}) {
    return Row(
      children: [
        Text(
          '$text: ',
          style: theme.textTheme.headline3,
        ),
        Text(
          '$count Р',
          style: theme.textTheme.headline5!.copyWith(fontSize: 16),
        )
      ],
    );
  }
}
