import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:intl/intl.dart';

class TimeFeed extends StatelessWidget {
  TimeFeed({Key? key}) : super(key: key);

  final DateTime time = DateTime(DateTime.now().year);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 36,
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 25,
        separatorBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 6),
              _buildCircle(),
              const SizedBox(height: 3),
              _dividerSmall(),
              const SizedBox(height: 5),
              _dividerBig(),
              const SizedBox(height: 4),
              _dividerBig(),
              const SizedBox(height: 4),
              _dividerBig(),
              const SizedBox(height: 4),
              _dividerBig(),
              const SizedBox(height: 5),
              _dividerSmall(),
              const SizedBox(height: 3),
              _buildCircle(),
              const SizedBox(height: 6),
            ],
          );
        },
        itemBuilder: (context, index) {
          int hour = time.hour + index;
          DateTime data = DateTime(
            time.year,
            time.month,
            time.day,
            hour,
          );
          return Text(
            DateFormat('HH:mm').format(data),
            style: theme.textTheme.bodyText2!.copyWith(
              color: Styles.greyLight5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircle() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Styles.greyLight6,
        border: Border.all(
          color: Styles.greyLight3,
        ),
        borderRadius: BorderRadius.circular(90),
      ),
    );
  }

  Widget _dividerSmall() {
    return Container(
      width: 1,
      height: 2.5,
      color: Styles.greyLight3,
    );
  }

  Widget _dividerBig() {
    return Container(
      width: 1,
      height: 5,
      color: Styles.greyLight3,
    );
  }
}
