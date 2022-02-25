import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/confirmation/confirmation.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_client.dart';
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
  const SignUpTrainingSessionPage({
    Key? key,
    required this.trainingRecordType,
  }) : super(key: key);

  final TrainingRecordType trainingRecordType;

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
          _scheduleController.clear();
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
                        /// Выбор клиента для не групповой тренировки
                        if (widget.trainingRecordType !=
                            TrainingRecordType.group)
                          Obx(
                            () => _buildContainer(
                              context: context,
                              theme: theme,
                              isCheckbox:
                                  _scheduleController.state.value.clients !=
                                          null
                                      ? true
                                      : false,
                              value: _scheduleController
                                      .state.value.clients?[0].arrivalStatus ??
                                  false,
                              text: _scheduleController
                                      .state.value.clients?[0].model.fullName ??
                                  S.of(context).select_client,
                              onTap: () async {
                                Get.to(
                                  () => SelectClientPage(
                                    trainingRecordType:
                                        widget.trainingRecordType,
                                  ),
                                  transition: Transition.fadeIn,
                                );
                              },
                              onChangedCheckBox: (activeCheckbox) {
                                _scheduleController.state.update((model) {
                                  model?.clients![0].arrivalStatus =
                                      activeCheckbox ?? false;
                                });
                              },
                            ),
                          ),
                        if (widget.trainingRecordType !=
                            TrainingRecordType.group)
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
                              if (widget.trainingRecordType !=
                                  TrainingRecordType.group) {
                                if (_scheduleController.state.value.clients !=
                                    null) {
                                  Picker.custom(
                                    context: context,
                                    theme: theme,
                                    values: _scheduleController
                                        .state.value.appointmentsDurations,
                                    onConfirm: (value) {
                                      _scheduleController.state.update((model) {
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
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 17),

                        /// Вид тренировки
                        if (widget.trainingRecordType !=
                            TrainingRecordType.group)
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
                                    split: _scheduleController.state.value.split
                                        ? TrainingType.split
                                        : TrainingType.personal,
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
                                          title: S.of(context).error,
                                          message: S
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
                                    split: _scheduleController.state.value.split
                                        ? TrainingType.personal
                                        : TrainingType.split,
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
                                          title: S.of(context).error,
                                          message: S
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
                        if (widget.trainingRecordType !=
                            TrainingRecordType.group)
                          const SizedBox(height: 17),

                        /// Услуга
                        Obx(
                          () => _buildContainer(
                            context: context,
                            theme: theme,
                            text:
                                _scheduleController.state.value.service?.name ??
                                    S.of(context).service,
                            onTap: () {
                              if (widget.trainingRecordType !=
                                  TrainingRecordType.group) {
                                if (_scheduleController.state.value.duration !=
                                    null) {
                                  Get.toNamed(Routes.selectService);
                                } else {
                                  CustomSnackbar.getSnackbar(
                                    title: S.of(context).error,
                                    message: S.of(context).fill_previous_fields,
                                  );
                                }
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
                            if (_scheduleController.state.value.date != null) {
                              dateEvent = DateFormat('EEEE d MMMM')
                                      .format(_scheduleController
                                          .state.value.date!)[0]
                                      .toUpperCase() +
                                  DateFormat('EEEE d MMMM')
                                      .format(
                                          _scheduleController.state.value.date!)
                                      .substring(1);
                            }

                            return _buildContainer(
                              context: context,
                              theme: theme,
                              text: dateEvent ?? S.of(context).date_event,
                              onTap: () async {
                                if (widget.trainingRecordType !=
                                    TrainingRecordType.group) {
                                  if (_scheduleController.state.value.service !=
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
                                      message:
                                          S.of(context).fill_previous_fields,
                                    );
                                  }
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
                                _scheduleController.state.value.time;
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
                                      _scheduleController.state.value.duration!,
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
                                if (widget.trainingRecordType !=
                                    TrainingRecordType.group) {
                                  if (_scheduleController.state.value.date !=
                                      null) {
                                    await DatePicker.showTimePicker(
                                      context,
                                      onConfirm: (confirmTime) async {
                                        _scheduleController.state
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
                                      message:
                                          S.of(context).fill_previous_fields,
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                        if (widget.trainingRecordType ==
                            TrainingRecordType.group)
                          const SizedBox(height: 17),

                        /// Выбор клиента для групповой тренировки
                        if (widget.trainingRecordType ==
                            TrainingRecordType.group)
                          Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _scheduleController
                                          .state.value.clients !=
                                      null
                                  ? _scheduleController
                                              .state.value.clients!.length ==
                                          _scheduleController
                                              .state.value.capacity
                                      ? _scheduleController.state.value.capacity
                                      : _scheduleController
                                              .state.value.clients!.length +
                                          1
                                  : 1,
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 17);
                              },
                              itemBuilder: (context, index) {
                                bool clientIsSelected =
                                    _scheduleController.state.value.clients !=
                                            null
                                        ? index !=
                                                _scheduleController
                                                    .state.value.clients!.length
                                            ? true
                                            : false
                                        : false;
                                return _buildContainer(
                                  context: context,
                                  theme: theme,
                                  isCheckbox: clientIsSelected,
                                  isButtonDelete: clientIsSelected,
                                  value: clientIsSelected
                                      ? _scheduleController.state.value
                                          .clients![index].arrivalStatus
                                      : false,
                                  text: clientIsSelected
                                      ? _scheduleController.state.value
                                          .clients![index].model.fullName
                                      : S.of(context).select_client,
                                  onTap: () async {
                                    Get.to(
                                      () => SelectClientPage(
                                        trainingRecordType:
                                            widget.trainingRecordType,
                                      ),
                                    );
                                  },
                                  onChangedCheckBox: (activeCheckbox) {
                                    clientIsSelected
                                        ? _scheduleController.state
                                            .update((model) {
                                            model?.clients![index]
                                                    .arrivalStatus =
                                                activeCheckbox ?? false;
                                          })
                                        : null;
                                  },
                                  onDelete: () {
                                    _scheduleController.state.update((model) {
                                      model?.clients!.removeAt(index);
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
                onTap: () {
                  if (_scheduleController.state.value.time != null) {
                    String dataTime =
                        '${DateFormat('d.MM.yy').format(_scheduleController.state.value.date!)} в '
                        '${DateFormat('HH:mm').format(_scheduleController.state.value.time!)}';
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
                              if (widget.trainingRecordType !=
                                  TrainingRecordType.group)
                                TextSpan(
                                  text:
                                      '${_scheduleController.state.value.clients![0].model.fullName}\n',
                                  style: theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              if (widget.trainingRecordType ==
                                  TrainingRecordType.group)
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
    bool isButtonDelete = false,
    bool value = false,
    Function(bool? activeCheckbox)? onChangedCheckBox,
    Function()? onDelete,
    _Animation? animation,
    TrainingType? split,
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
        width: split == _scheduleController.state.value.type
            ? animation?.activeWidth ??
                width ??
                MediaQuery.of(context).size.width
            : animation?.inactiveWidth ??
                width ??
                MediaQuery.of(context).size.width,
        height: split == _scheduleController.state.value.type
            ? animation?.activeHeight
            : animation?.inactiveHeight,
        decoration: BoxDecoration(
          border: split == _scheduleController.state.value.type
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
                      ? split == _scheduleController.state.value.type
                          ? theme.textTheme.bodyText1!
                          : theme.textTheme.bodyText1!.copyWith(fontSize: 12)
                      : theme.textTheme.bodyText1!,
                  duration: Duration(milliseconds: animation?.duration ?? 0),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: isButtonDelete ? 15 : 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCheckbox)
                    Checkbox(
                      value: value,
                      activeColor: theme.colorScheme.primary,
                      side:
                          const BorderSide(color: Styles.greyLight5, width: 1),
                      onChanged: (activeCheckbox) {
                        if (onChangedCheckBox != null) {
                          onChangedCheckBox(activeCheckbox);
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
              ),
            )
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
