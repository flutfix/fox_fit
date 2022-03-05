import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:fox_fit/utils/picker/picker.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swipe/swipe.dart';

class SignUpTrainingSessionPage extends StatefulWidget {
  const SignUpTrainingSessionPage({Key? key}) : super(key: key);

  @override
  _SignUpTrainingSessionPageState createState() =>
      _SignUpTrainingSessionPageState();
}

class _SignUpTrainingSessionPageState extends State<SignUpTrainingSessionPage> {
  late bool _isLoading;
  late ScheduleController _scheduleController;

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
    return Swipe(
      onSwipeRight: () {
        _scheduleController.clear(appointment: true);
        Get.back();
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(
          title: S.of(context).sign_up_training_session,
          isNotification: false,
          isBackArrow: true,

          /// Кнопка удаления тернировки
          action: _scheduleController.state.value.appointmentRecordType ==
                  AppointmentRecordType.edit
              ? GestureDetector(
                  onTap: () {
                    _scheduleController.state.update((model) {
                      model?.appointmentRecordType =
                          AppointmentRecordType.revoke;
                    });
                    Get.to(
                      () => ConfirmationPage(
                        stagePipelineType: StagePipelineType.appointment,
                        textButtonDone: S.of(context).revoke,
                        textButtonCancel: S.of(context).back,
                        richText: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '${S.of(context).cancel_workout}\n',
                                style: theme.textTheme.headline5,
                              ),
                              TextSpan(
                                text: _scheduleController
                                    .state.value.clients[0].model.fullName,
                                style: theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: ' ?',
                                style: theme.textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      transition: Transition.fadeIn,
                    );
                  },
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
                )
              : null,
          onBack: () {
            _scheduleController.clear(appointment: true);
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
                          /// Выбор клиента для персональной тренировки
                          if (_scheduleController
                                  .state.value.appointmentRecordType !=
                              AppointmentRecordType.group)
                            Obx(
                              () => _buildContainer(
                                context: context,
                                theme: theme,
                                text: _scheduleController
                                        .state.value.clients.isNotEmpty
                                    ? _scheduleController
                                        .state.value.clients[0].model.fullName
                                    : S.of(context).select_client,
                                onTap: () {
                                  Get.toNamed(Routes.selectClient);
                                },
                                onCheckBox: (activeCheckbox) {
                                  _scheduleController.state.update((model) {
                                    model?.clients[0].arrivalStatus =
                                        activeCheckbox;
                                  });
                                },
                              ),
                            ),
                          if (_scheduleController
                                  .state.value.appointmentRecordType !=
                              AppointmentRecordType.group)
                            const SizedBox(height: 17),

                          /// Длительность
                          Obx(
                            () => _buildContainer(
                              context: context,
                              theme: theme,
                              text: _scheduleController.state.value.duration !=
                                      null
                                  ? '${_scheduleController.state.value.duration} мин'
                                  : S.of(context).duration,
                              onTap: () async {
                                if (_scheduleController
                                        .state.value.appointmentRecordType !=
                                    AppointmentRecordType.group) {
                                  if (_scheduleController
                                      .state.value.clients.isNotEmpty) {
                                    Picker.custom(
                                      context: context,
                                      values: _scheduleController
                                          .state.value.appointmentsDurations,
                                      onConfirm: (value) {
                                        if (value !=
                                            _scheduleController
                                                .state.value.duration) {
                                          _scheduleController.state
                                              .update((model) {
                                            model?.service = null;
                                            model?.duration = value;
                                          });
                                        }
                                      },
                                    );
                                  } else {
                                    CustomSnackbar.getSnackbar(
                                      title: S.of(context).fill_previous_fields,
                                    );
                                  }
                                } else {
                                  CustomSnackbar.getSnackbar(
                                    title: S
                                        .of(context)
                                        .only_add_or_remove_clients,
                                    duration: 3,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 17),

                          /// Вид тренировки
                          if (_scheduleController
                                  .state.value.appointmentRecordType !=
                              AppointmentRecordType.group)
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
                                      isActive:
                                          _scheduleController.state.value.split
                                              ? false
                                              : true,
                                      animation: _Animation(activeWidth: 144),
                                      wrapText: false,
                                      onTap: () {
                                        if (_scheduleController
                                                .state.value.duration !=
                                            null) {
                                          _scheduleController.state
                                              .update((model) {
                                            model?.split = false;
                                          });
                                        } else {
                                          CustomSnackbar.getSnackbar(
                                            title: S
                                                .of(context)
                                                .fill_previous_fields,
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
                                      isActive:
                                          _scheduleController.state.value.split
                                              ? true
                                              : false,
                                      wrapText: false,
                                      onTap: () {
                                        if (_scheduleController
                                                .state.value.duration !=
                                            null) {
                                          _scheduleController.state
                                              .update((model) {
                                            model?.split = true;
                                          });
                                        } else {
                                          CustomSnackbar.getSnackbar(
                                            title: S
                                                .of(context)
                                                .fill_previous_fields,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_scheduleController
                                  .state.value.appointmentRecordType !=
                              AppointmentRecordType.group)
                            const SizedBox(height: 17),

                          /// Услуга
                          Obx(
                            () => _buildContainer(
                              context: context,
                              theme: theme,
                              text: _scheduleController
                                      .state.value.service?.name ??
                                  S.of(context).service,
                              onTap: () {
                                if (_scheduleController
                                        .state.value.appointmentRecordType !=
                                    AppointmentRecordType.group) {
                                  if (_scheduleController
                                          .state.value.duration !=
                                      null) {
                                    Get.toNamed(Routes.selectService);
                                  } else {
                                    CustomSnackbar.getSnackbar(
                                      title: S.of(context).fill_previous_fields,
                                    );
                                  }
                                } else {
                                  CustomSnackbar.getSnackbar(
                                    title: S
                                        .of(context)
                                        .only_add_or_remove_clients,
                                    duration: 3,
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
                              if (_scheduleController.state.value.date !=
                                  null) {
                                dateEvent = DateFormat('EEEE d MMMM')
                                        .format(_scheduleController
                                            .state.value.date!)[0]
                                        .toUpperCase() +
                                    DateFormat('EEEE d MMMM')
                                        .format(_scheduleController
                                            .state.value.date!)
                                        .substring(1);
                              }

                              return _buildContainer(
                                context: context,
                                theme: theme,
                                text: dateEvent ?? S.of(context).date_event,
                                onTap: () async {
                                  if (_scheduleController
                                          .state.value.appointmentRecordType !=
                                      AppointmentRecordType.group) {
                                    if (_scheduleController
                                            .state.value.service !=
                                        null) {
                                      await DatePicker.showDatePicker(
                                        context,
                                        onConfirm: (confirmTime) async {
                                          _scheduleController.state
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
                                          cancelStyle:
                                              theme.textTheme.headline2!,
                                          doneStyle:
                                              theme.primaryTextTheme.headline2!,
                                          itemStyle: theme.textTheme.headline2!,
                                          backgroundColor:
                                              theme.backgroundColor,
                                          headerColor: theme.backgroundColor,
                                        ),
                                      );
                                    } else {
                                      CustomSnackbar.getSnackbar(
                                        title:
                                            S.of(context).fill_previous_fields,
                                      );
                                    }
                                  } else {
                                    CustomSnackbar.getSnackbar(
                                      title: S
                                          .of(context)
                                          .only_add_or_remove_clients,
                                      duration: 3,
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
                                  _scheduleController.state.value.duration !=
                                          null
                                      ? _scheduleController.state.value.time
                                      : null;
                              if (selectedTime != null) {
                                timeEventStart = DateFormat('HH:mm').format(
                                  _scheduleController.state.value.time!,
                                );
                                timeEventEnd = DateFormat('HH:mm').format(
                                  DateTime(
                                    selectedTime.year,
                                    selectedTime.month,
                                    selectedTime.day,
                                    selectedTime.hour,
                                    selectedTime.minute +
                                        _scheduleController
                                            .state.value.duration!,
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
                                          .state.value.appointmentRecordType !=
                                      AppointmentRecordType.group) {
                                    if (_scheduleController.state.value.date !=
                                            null &&
                                        _scheduleController
                                                .state.value.service !=
                                            null) {
                                      await Picker.time(
                                        context: context,
                                        currentHour: _scheduleController
                                                .state.value.time?.hour ??
                                            DateTime.now().hour,
                                        minutesInterval: 5,
                                        onConfirm: (confirmTime) async {
                                          _scheduleController.state
                                              .update((model) {
                                            model?.time = confirmTime;
                                          });
                                        },
                                        buttonsStyle:
                                            theme.textTheme.headline2!,
                                        valueStyle: theme.textTheme.headline2!,
                                        doneButtonColor:
                                            theme.colorScheme.primary,
                                        borderRadius: BorderRadius.zero,
                                      );
                                    } else {
                                      CustomSnackbar.getSnackbar(
                                        title:
                                            S.of(context).fill_previous_fields,
                                      );
                                    }
                                  } else {
                                    CustomSnackbar.getSnackbar(
                                      title: S
                                          .of(context)
                                          .only_add_or_remove_clients,
                                      duration: 3,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          if (_scheduleController
                                  .state.value.appointmentRecordType ==
                              AppointmentRecordType.group)
                            const SizedBox(height: 17),

                          /// Выбор клиента для групповой тренировки
                          if (_scheduleController
                                  .state.value.appointmentRecordType ==
                              AppointmentRecordType.group)
                            Obx(
                              () => ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _scheduleController
                                            .state.value.clients.length ==
                                        _scheduleController.state.value.capacity
                                    ? _scheduleController.state.value.capacity
                                    : _scheduleController
                                            .state.value.clients.length +
                                        1,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 17);
                                },
                                itemBuilder: (context, index) {
                                  /// Для отображения чекбокса
                                  bool clientIsSelected = index !=
                                          _scheduleController
                                              .state.value.clients.length
                                      ? true
                                      : false;
                                  return _buildContainer(
                                    context: context,
                                    theme: theme,
                                    isCheckbox: clientIsSelected,
                                    isButtonDelete: clientIsSelected,
                                    arrivalStatus: clientIsSelected
                                        ? _scheduleController.state.value
                                            .clients[index].arrivalStatus
                                        : false,
                                    text: clientIsSelected
                                        ? _scheduleController.state.value
                                            .clients[index].model.fullName
                                        : S.of(context).select_client,
                                    onTap: () async {
                                      Get.toNamed(Routes.selectClient);
                                    },
                                    onCheckBox: (activeCheckbox) {
                                      _scheduleController.state.update((model) {
                                        model?.clients[index].arrivalStatus =
                                            activeCheckbox;
                                      });
                                    },
                                    onDelete: () {
                                      _scheduleController.state.update((model) {
                                        model?.clients.removeAt(index);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 75),
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
                  height: 51,
                  text: _scheduleController.state.value.appointmentRecordType ==
                          AppointmentRecordType.edit
                      ? S.of(context).save
                      : S.of(context).record,
                  backgroundColor: theme.colorScheme.secondary,
                  textStyle: theme.textTheme.button!,
                  onTap: () {
                    if (validateFields()) {
                      String dataTimeString =
                          '${DateFormat('d.MM.yy').format(_scheduleController.state.value.date!)} в '
                          '${DateFormat('HH:mm').format(_scheduleController.state.value.time!)}';
                      Get.to(
                        () => ConfirmationPage(
                          textButtonDone: _scheduleController
                                      .state.value.appointmentRecordType ==
                                  AppointmentRecordType.edit
                              ? S.of(context).save
                              : S.of(context).record,
                          textButtonCancel: S.of(context).back,
                          richText: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${S.of(context).record}\n',
                                  style: theme.textTheme.headline5,
                                ),
                                if (_scheduleController
                                        .state.value.appointmentRecordType !=
                                    AppointmentRecordType.group)
                                  TextSpan(
                                    text:
                                        '${_scheduleController.state.value.clients[0].model.fullName}\n',
                                    style: theme.textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                if (_scheduleController
                                        .state.value.appointmentRecordType ==
                                    AppointmentRecordType.group)
                                  TextSpan(
                                    text:
                                        '${S.of(context).selected_clients.toLowerCase()}\n',
                                    style: theme.textTheme.headline5,
                                  ),
                                TextSpan(
                                  text:
                                      '${S.of(context).to_practice.toLowerCase()} ',
                                  style: theme.textTheme.headline5,
                                ),
                                TextSpan(
                                  text: '$dataTimeString?',
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
                        title: _scheduleController
                                    .state.value.appointmentRecordType ==
                                AppointmentRecordType.group
                            ? S.of(context).add_least_one_client
                            : S.of(context).fill_all_fields,
                      );
                    }
                  },
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildContainer({
    required BuildContext context,
    required ThemeData theme,
    required String text,
    required Function() onTap,
    bool isCheckbox = false,
    bool isButtonDelete = false,
    Function(bool activeCheckbox)? onCheckBox,
    Function()? onDelete,
    _Animation? animation,
    bool isActive = true,
    bool arrivalStatus = false,
    bool wrapText = true,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: animation?.duration ?? 0),
        curve: Curves.easeOut,
        width: isActive ? animation?.activeWidth : animation?.inactiveWidth,
        height: isActive ? animation?.activeHeight : animation?.inactiveHeight,
        padding: animation != null
            ? const EdgeInsets.symmetric(vertical: 14, horizontal: 11)
            : const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          border: animation != null
              ? isActive
                  ? Border.all(color: theme.colorScheme.secondary)
                  : null
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: wrapText ? MediaQuery.of(context).size.width - 140 : null,
              child: AnimatedDefaultTextStyle(
                child: Text(text),
                style: isActive
                    ? theme.textTheme.bodyText1!
                    : theme.textTheme.bodyText1!.copyWith(fontSize: 12),
                duration: Duration(milliseconds: animation?.duration ?? 0),
                curve: Curves.easeOut,
              ),
            ),
            Row(
              children: [
                if (isCheckbox)
                  Checkbox(
                    value: arrivalStatus,
                    activeColor: theme.colorScheme.primary,
                    side: const BorderSide(color: Styles.greyLight5, width: 1),
                    onChanged: (value) {
                      if (onCheckBox != null) {
                        onCheckBox(value ?? false);
                      }
                    },
                  ),
                if (isButtonDelete)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (onDelete != null) {
                        onDelete();
                      }
                    },
                    child: SvgPicture.asset(
                      Images.cross,
                      width: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateFields() {
    if (_scheduleController.state.value.clients.isNotEmpty &&
        _scheduleController.state.value.duration != null &&
        _scheduleController.state.value.service != null &&
        _scheduleController.state.value.date != null &&
        _scheduleController.state.value.time != null) {
      return true;
    } else {
      return false;
    }
  }
}

/// Конфигурация анимации для выбора типа (Персональной или Сплит)
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
