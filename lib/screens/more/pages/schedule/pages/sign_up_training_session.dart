import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/confirmation/confirmation.dart';
import 'package:fox_fit/utils/date_time_picker/date_time_picker.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/date_time_picker_theme.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/i18n_model.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/picker.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignUpTrainingSessionPage extends StatefulWidget {
  const SignUpTrainingSessionPage({Key? key}) : super(key: key);

  @override
  _SignUpTrainingSessionPageState createState() =>
      _SignUpTrainingSessionPageState();
}

class _SignUpTrainingSessionPageState extends State<SignUpTrainingSessionPage> {
  late bool _isLoading;
  late ScheduleController _scheduleController;
  bool? _activeCheckbox = false;

  @override
  void initState() {
    super.initState();
    _scheduleController = Get.find<ScheduleController>();

    getAppointmentsDurations();
  }

  Future<void> getAppointmentsDurations() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: _scheduleController.getAppointmentsDurations,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: CustomAppBar(
        title: S.of(context).sign_up_training_session,
        isNotification: false,
        isBackArrow: true,
        action: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Image.asset(
                Images.trashcan,
                width: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 36)
            ],
          ),
        ),
        onBack: () {
          _scheduleController.scheduleState.update((model) {
            model?.client = null;
            model?.duration = null;
            model?.type = TrainingType.personal;
            model?.service = null;
            model?.date = null;
            model?.time = null;
          });
          Get.back();
        },
      ),
      body: !_isLoading
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        /// Выбор клиента
                        Obx(
                          () => _buildContainer(
                            context: context,
                            theme: theme,
                            isCheckbox: true,
                            text: _scheduleController
                                    .scheduleState.value.client?.fullName ??
                                S.of(context).select_client,
                            onTap: () async {
                              Get.toNamed(Routes.selectClient);
                            },
                          ),
                        ),
                        const SizedBox(height: 17),

                        /// Длительность
                        Obx(
                          () => _buildContainer(
                            context: context,
                            theme: theme,
                            text: _scheduleController
                                        .scheduleState.value.duration !=
                                    null
                                ? '${_scheduleController.scheduleState.value.duration} мин'
                                : S.of(context).duration,
                            onTap: () async {
                              if (_scheduleController
                                      .scheduleState.value.client !=
                                  null) {
                                Picker.custom(
                                  context: context,
                                  theme: theme,
                                  values: _scheduleController.scheduleState
                                      .value.appointmentsDurations,
                                  onConfirm: (value) {
                                    _scheduleController.scheduleState
                                        .update((model) {
                                      model?.duration = value;
                                    });
                                  },
                                );
                              } else {
                                CustomSnackbar.getSnackbar(
                                  title: S.of(context).error,
                                  message: S.of(context).fill_previous_fields,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 17),

                        /// Вид тренировки
                        SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              /// Персональная
                              Obx(
                                () => _buildContainer(
                                  context: context,
                                  theme: theme,
                                  text: S.of(context).personal,
                                  animation: _Animation(activeWidth: 144),
                                  type: TrainingType.personal,
                                  onTap: () {
                                    if (_scheduleController
                                            .scheduleState.value.duration !=
                                        null) {
                                      _scheduleController.scheduleState
                                          .update((model) {
                                        model?.type = TrainingType.personal;
                                      });
                                    } else {
                                      CustomSnackbar.getSnackbar(
                                        title: S.of(context).error,
                                        message:
                                            S.of(context).fill_previous_fields,
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 7),

                              /// Сплит
                              Obx(
                                () => _buildContainer(
                                  context: context,
                                  theme: theme,
                                  text: S.of(context).split,
                                  animation: _Animation(
                                    activeWidth: 77,
                                    inactiveWidth: 60,
                                  ),
                                  type: TrainingType.group,
                                  onTap: () {
                                    if (_scheduleController
                                            .scheduleState.value.duration !=
                                        null) {
                                      _scheduleController.scheduleState
                                          .update((model) {
                                        model?.type = TrainingType.group;
                                      });
                                    } else {
                                      CustomSnackbar.getSnackbar(
                                        title: S.of(context).error,
                                        message:
                                            S.of(context).fill_previous_fields,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 17),

                        /// Услуга
                        Obx(
                          () => _buildContainer(
                            context: context,
                            theme: theme,
                            text: _scheduleController
                                    .scheduleState.value.service?.name ??
                                S.of(context).service,
                            onTap: () {
                              if (_scheduleController
                                      .scheduleState.value.duration !=
                                  null) {
                                Get.toNamed(Routes.selectService);
                              } else {
                                CustomSnackbar.getSnackbar(
                                  title: S.of(context).error,
                                  message: S.of(context).fill_previous_fields,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 17),

                        /// Дата проведения
                        Obx(
                          () {
                            /// Преобразование даты в нужный формат
                            String? dateEvent;
                            if (_scheduleController.scheduleState.value.date !=
                                null) {
                              dateEvent = DateFormat('EEEE d MMMM')
                                      .format(_scheduleController
                                          .scheduleState.value.date!)[0]
                                      .toUpperCase() +
                                  DateFormat('EEEE d MMMM')
                                      .format(_scheduleController
                                          .scheduleState.value.date!)
                                      .substring(1);
                            }

                            return _buildContainer(
                              context: context,
                              theme: theme,
                              text: dateEvent ?? S.of(context).date_event,
                              onTap: () async {
                                if (_scheduleController
                                        .scheduleState.value.service !=
                                    null) {
                                  await DatePicker.showDatePicker(
                                    context,
                                    onConfirm: (confirmTime) async {
                                      _scheduleController.scheduleState
                                          .update((model) {
                                        model?.date = confirmTime;
                                      });
                                    },
                                    minTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    ),
                                    locale: LocaleType.ru,
                                    currentTime: DateTime.now(),
                                    theme: DatePickerTheme(
                                      cancelStyle: theme.textTheme.headline2!,
                                      doneStyle:
                                          theme.primaryTextTheme.headline2!,
                                      itemStyle: theme.textTheme.headline2!,
                                      backgroundColor: theme.backgroundColor,
                                      headerColor: theme.backgroundColor,
                                    ),
                                  );
                                } else {
                                  CustomSnackbar.getSnackbar(
                                    title: S.of(context).error,
                                    message: S.of(context).fill_previous_fields,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 17),

                        /// Время проведения
                        Obx(
                          () {
                            /// Преобразование времени в нужный формат
                            String? timeEventStart;
                            String? timeEventEnd;
                            DateTime? selectedTime =
                                _scheduleController.scheduleState.value.time;
                            if (selectedTime != null) {
                              timeEventStart = DateFormat('HH:mm').format(
                                _scheduleController.scheduleState.value.time!,
                              );
                              timeEventEnd = DateFormat('HH:mm').format(
                                DateTime(
                                  selectedTime.year,
                                  selectedTime.month,
                                  selectedTime.day,
                                  selectedTime.hour,
                                  selectedTime.minute +
                                      _scheduleController
                                          .scheduleState.value.duration!,
                                ),
                              );
                            }
                            return _buildContainer(
                              context: context,
                              theme: theme,
                              text: selectedTime != null
                                  ? 'c $timeEventStart до $timeEventEnd'
                                  : S.of(context).time_lesson,
                              onTap: () async {
                                if (_scheduleController
                                        .scheduleState.value.date !=
                                    null) {
                                  await DatePicker.showTimePicker(
                                    context,
                                    onConfirm: (confirmTime) async {
                                      _scheduleController.scheduleState
                                          .update((model) {
                                        model?.time = confirmTime;
                                      });
                                    },
                                    locale: LocaleType.ru,
                                    currentTime: DateTime.now(),
                                    showSecondsColumn: false,
                                    theme: DatePickerTheme(
                                      cancelStyle: theme.textTheme.headline2!,
                                      doneStyle:
                                          theme.primaryTextTheme.headline2!,
                                      itemStyle: theme.textTheme.headline2!,
                                      backgroundColor: theme.backgroundColor,
                                      headerColor: theme.backgroundColor,
                                    ),
                                  );
                                } else {
                                  CustomSnackbar.getSnackbar(
                                    title: S.of(context).error,
                                    message: S.of(context).fill_previous_fields,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
      floatingActionButton: !_isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: CustomTextButton(
                onTap: () {
                  if (_scheduleController.scheduleState.value.time != null) {
                    String dataTime =
                        '${DateFormat('d.MM.yy').format(_scheduleController.scheduleState.value.date!)} в '
                        '${DateFormat('HH:mm').format(_scheduleController.scheduleState.value.time!)}';
                    Get.to(
                      () => ConfirmationPage(
                        stagePipelineType: StagePipelineType.training,
                        textButtonDone: S.of(context).record,
                        textButtonCancel: S.of(context).back,
                        richText: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '${S.of(context).record}\n',
                                style: theme.textTheme.headline5,
                              ),
                              TextSpan(
                                text:
                                    '${_scheduleController.scheduleState.value.client!.fullName}\n',
                                style: theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${S.of(context).to_practice.toLowerCase()} ',
                                style: theme.textTheme.headline5,
                              ),
                              TextSpan(
                                text: '$dataTime?',
                                style: theme.textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      transition: Transition.fadeIn,
                    );
                  } else {
                    CustomSnackbar.getSnackbar(
                      title: S.of(context).error,
                      message: S.of(context).fill_all_fields,
                    );
                  }
                },
                height: 51,
                text: S.of(context).record,
                backgroundColor: theme.colorScheme.secondary,
                textStyle: theme.textTheme.button!,
              ),
            )
          : null,
    );
  }

  Widget _buildContainer({
    required BuildContext context,
    required ThemeData theme,
    required String text,
    required Function() onTap,
    bool isCheckbox = false,
    _Animation? animation,
    TrainingType? type,
    double? width,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: animation?.duration ?? 0),
        curve: Curves.easeOut,
        width: type == _scheduleController.scheduleState.value.type
            ? animation?.activeWidth ??
                width ??
                MediaQuery.of(context).size.width
            : animation?.inactiveWidth ??
                width ??
                MediaQuery.of(context).size.width,
        height: type == _scheduleController.scheduleState.value.type
            ? animation?.activeHeight
            : animation?.inactiveHeight,
        decoration: BoxDecoration(
          border: type == _scheduleController.scheduleState.value.type
              ? Border.all(color: theme.colorScheme.secondary)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            DefaultContainer(
              padding: animation != null
                  ? const EdgeInsets.symmetric(vertical: 14, horizontal: 11)
                  : const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedDefaultTextStyle(
                  child: Text(text),
                  style: animation != null
                      ? type == _scheduleController.scheduleState.value.type
                          ? theme.textTheme.bodyText1!
                          : theme.textTheme.bodyText1!.copyWith(fontSize: 12)
                      : theme.textTheme.bodyText1!,
                  duration: Duration(milliseconds: animation?.duration ?? 0),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            isCheckbox
                ? Checkbox(
                    value:
                        _scheduleController.scheduleState.value.arrivalStatuses,
                    activeColor: theme.colorScheme.primary,
                    side: const BorderSide(color: Styles.greyLight5, width: 1),
                    onChanged: (activeCheckbox) {
                      _scheduleController.scheduleState.update((model) {
                        model?.arrivalStatuses = activeCheckbox ?? false;
                      });
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class _Animation {
  _Animation({
    this.activeWidth = 145,
    this.activeHeight = 60,
    this.inactiveWidth = 111,
    this.inactiveHeight = 46,
    this.duration = 150,
  });

  double activeWidth;
  double activeHeight;
  double inactiveWidth;
  double inactiveHeight;
  int duration;
}
