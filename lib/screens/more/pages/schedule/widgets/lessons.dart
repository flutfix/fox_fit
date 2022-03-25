import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/customer_model_state.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Lessons extends StatelessWidget {
  Lessons({
    Key? key,
    required this.date,
  }) : super(key: key);

  final ScheduleController _scheduleController = Get.find<ScheduleController>();
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: (width - 106),
      child: ListView.separated(
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
        itemBuilder: (context, indexVer) {
          List<AppointmentModel> appointments = _searchLesson(index: indexVer);
          return SizedBox(
            height: 89,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: appointments.isNotEmpty ? appointments.length : 1,
              separatorBuilder: (context, index) {
                return Column(
                  children: const [
                    SizedBox(width: 7),
                  ],
                );
              },
              itemBuilder: (context, indexHor) {
                /// Проверка, есть ли статус оплаты
                PaymentStatusType? paymentStatusType;
                if (appointments.isNotEmpty) {
                  if (appointments[indexHor].arrivalStatuses.isNotEmpty) {
                    paymentStatusType = Enums.getPaymentStatusType(
                      paymentStatusString: appointments[indexHor]
                          .arrivalStatuses[0]
                          .paymentStatus,
                    );
                  }
                }

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _scheduleController.clear(appointment: true);
                    if (appointments.isNotEmpty) {
                      /// Преобразование клиента и его статуса
                      /// с запроса к виду модели на фронте
                      List<CustomerModelState> clients = [];
                      for (var customer in appointments[indexHor].customers) {
                        clients.add(
                          CustomerModelState(
                            model: customer,
                            arrivalStatus: appointments[indexHor]
                                .arrivalStatuses
                                .firstWhere((element) =>
                                    element.customerUid == customer.uid)
                                .status,
                          ),
                        );
                      }

                      /// Автозаполнение форм для существующей тренировки
                      /// *Проверка на то, прошло ли занятие*
                      var appointmentEndDate =
                          appointments[indexHor].endDate.millisecondsSinceEpoch;
                      dynamic timeOffset =
                          DateTime.now().timeZoneOffset.toString();
                      timeOffset = timeOffset.split(':');
                      int timeDiff = int.parse(timeOffset[0]);

                      DateTime now = DateTime.now();
                      var nowTimeStamp = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        now.hour + timeDiff,
                        now.minute,
                      ).toUtc().millisecondsSinceEpoch;

                      bool isView = nowTimeStamp > appointmentEndDate;
                      String status = '';
                      if (appointments[indexHor].arrivalStatuses.isNotEmpty) {
                        status = appointments[indexHor]
                            .arrivalStatuses[0]
                            .paymentStatus;
                      }
                      isView = status != ''
                          ? status == 'DoneAndPayed'
                              ? isView
                              : false
                          : false;
                      log('[Status] $status');
                      log('[Is View] $isView');
                      //**
                      _scheduleController.state.update((model) {
                        model?.appointment = appointments[indexHor];
                        model?.clients = clients;
                        model?.duration =
                            appointments[indexHor].service.duration;
                        model?.split = appointments[indexHor].service.split;
                        model?.service = appointments[indexHor].service;
                        model?.capacity = appointments[indexHor].capacity;
                        model?.date = appointments[indexHor].startDate;
                        model?.time = appointments[indexHor].startDate;
                        if (isView) {
                          model?.appointmentRecordType =
                              AppointmentRecordType.view;
                        } else {
                          model?.appointmentRecordType =
                              appointments[indexHor].appointmentType ==
                                      AppointmentType.personal
                                  ? AppointmentRecordType.edit
                                  : AppointmentRecordType.group;
                        }
                      });
                    }

                    /// Автозаполнение форм для пустой тренировки
                    if (appointments.isEmpty) {
                      _scheduleController.state.update((model) {
                        model?.date = date;
                        model?.time =
                            DateTime(date.year, date.month, date.day, indexVer);
                        model?.appointmentRecordType =
                            AppointmentRecordType.create;
                      });
                    }

                    Get.toNamed(Routes.signUpTrainingSession);
                  },
                  child: DefaultContainer(
                    width: appointments.length > 1
                        ? MediaQuery.of(context).size.width - 150
                        : MediaQuery.of(context).size.width - 106,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: appointments.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Имя клиента или назвние групповой тренировки
                              Text(
                                appointments[indexHor].appointmentType ==
                                        AppointmentType.personal
                                    ? appointments[indexHor]
                                        .customers[0]
                                        .fullName
                                    : appointments[indexHor].service.name,
                                style: theme.textTheme.headline3!.copyWith(
                                  fontSize: 16,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  /// Отображение статуса прихода и оплаты
                                  if (paymentStatusType != null &&
                                      appointments[indexHor].appointmentType !=
                                          AppointmentType.group)
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: paymentStatusType ==
                                                PaymentStatusType.doneAndPayed
                                            ? Styles.green
                                            : paymentStatusType ==
                                                    PaymentStatusType
                                                        .plannedAndPayed
                                                ? Styles.yellow
                                                : Styles.red,
                                        borderRadius: BorderRadius.circular(90),
                                      ),
                                    ),
                                  if (paymentStatusType != null &&
                                      appointments[indexHor].appointmentType !=
                                          AppointmentType.group)
                                    const SizedBox(width: 6),
                                  Text(
                                    '${appointments[indexHor].service.duration} мин '
                                    'с ${DateFormat('HH:mm').format(appointments[indexHor].startDate)}'
                                    ' до ${DateFormat('HH:mm').format(appointments[indexHor].endDate)}',
                                    style: theme.textTheme.headline3!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(height: 89),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Сравнивает час каждого занятия с часом ленты времени, являющимся [index]
  List<AppointmentModel> _searchLesson({required int index}) {
    List<AppointmentModel> appointments = [];
    for (var appointment in _scheduleController.state.value.appointments) {
      int hour = int.parse(DateFormat('H').format(appointment.startDate));
      if (hour == index) {
        appointments.add(appointment);
      }
    }
    return appointments;
  }
}
