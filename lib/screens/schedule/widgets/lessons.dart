import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Lessons extends StatelessWidget {
  Lessons({Key? key}) : super(key: key);

  final GeneralController _controller = Get.find<GeneralController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: (width - 106),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 24,
        separatorBuilder: (context, index) {
          return Column(
            children: const [
              SizedBox(height: 7),
            ],
          );
        },
        itemBuilder: (context, index) {
          AppointmentModel? appointment = searchLesson(index: index);
          return DefaultContainer(
            height: 89,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: appointment != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.customers![0].fullName,
                        style: theme.textTheme.headline3!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Styles.greyLight7,
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${appointment.service!.duration} мин '
                            'с ${DateFormat('HH:mm').format(appointment.startDate!)}'
                            ' до ${DateFormat('HH:mm').format(appointment.endDate!)}',
                            style: theme.textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : const SizedBox(height: 89),
          );
        },
      ),
    );
  }

  /// Сравнивает час каждого занятия с часом ленты времени, являющимся [index]
  AppointmentModel? searchLesson({required int index}) {
    for (var appointment in _controller.appState.value.appointments) {
      int hour = int.parse(DateFormat('H').format(appointment.startDate!));
      if (hour == index) {
        return appointment;
      }
    }
    return null;
  }
}
