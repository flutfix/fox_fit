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
          PaymentStatusType? paymentStatusType;

          /// Статус оплаты для персональной тренировки
          if (appointment != null) {
            if (appointment.arrivalStatuses.isNotEmpty) {
              paymentStatusType = Enums.getPaymentStatusType(
                paymentStatusString:
                    appointment.arrivalStatuses[0].paymentStatus,
              );
            }
          }

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (appointment != null) {
                /// Преобразование клиента и его статуса
                /// с запроса к виду модели на фронте
                List<CustomerModelState> clients = [];
                for (var customer in appointment.customers) {
                  clients.add(
                    CustomerModelState(
                      model: customer,
                      arrivalStatus: appointment.arrivalStatuses
                          .firstWhere(
                              (element) => element.customerUid == customer.uid)
                          .status,
                    ),
                  );
                }

                /// Автозаполнение форм для существующей тренировки
                _scheduleController.state.update((model) {
                  model?.appointment = appointment;
                  model?.clients = clients;
                  model?.duration = appointment.service.duration;
                  model?.split = appointment.service.split;
                  model?.service = appointment.service;
                  model?.capacity = appointment.capacity;
                  model?.date = appointment.startDate;
                  model?.time = appointment.startDate;
                  model?.appointmentRecordType =
                      appointment.appointmentType == AppointmentType.personal
                          ? AppointmentRecordType.edit
                          : AppointmentRecordType.group;
                });
              }

              /// Автозаполнение форм для пустой тренировки
              if (appointment == null) {
                _scheduleController.state.update((model) {
                  model?.date = date;
                  model?.time =
                      DateTime(date.year, date.month, date.day, index);
                  model?.appointmentRecordType = AppointmentRecordType.create;
                });
              }

              Get.toNamed(Routes.signUpTrainingSession);
            },
            child: DefaultContainer(
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: appointment != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Имя клиента или назвние групповой тренировки
                        Text(
                          appointment.appointmentType ==
                                  AppointmentType.personal
                              ? appointment.customers[0].fullName
                              : appointment.service.name,
                          style: theme.textTheme.headline3!.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            /// Отображение статуса прихода и оплаты
                            if (paymentStatusType != null &&
                                appointment.appointmentType !=
                                    AppointmentType.group)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: paymentStatusType ==
                                          PaymentStatusType.doneAndPayed
                                      ? Styles.green
                                      : paymentStatusType ==
                                              PaymentStatusType.plannedAndPayed
                                          ? Styles.yellow
                                          : Styles.red,
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                            if (paymentStatusType != null &&
                                appointment.appointmentType !=
                                    AppointmentType.group)
                              const SizedBox(width: 6),
                            Text(
                              '${appointment.service.duration} мин '
                              'с ${DateFormat('HH:mm').format(appointment.startDate)}'
                              ' до ${DateFormat('HH:mm').format(appointment.endDate)}',
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
  }

  /// Сравнивает час каждого занятия с часом ленты времени, являющимся [index]
  AppointmentModel? searchLesson({required int index}) {
    for (var appointment in _scheduleController.state.value.appointments) {
      int hour = int.parse(DateFormat('H').format(appointment.startDate));
      if (hour == index) {
        return appointment;
      }
    }
    return null;
  }
}
