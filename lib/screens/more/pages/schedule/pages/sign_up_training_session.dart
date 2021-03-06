import 'package:flutter/material.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/animation.dart';
import 'package:fox_fit/screens/confirmation/confirmation.dart';
import 'package:fox_fit/utils/date_time_picker/date_time_picker.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/date_time_picker_theme.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/i18n_model.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/picker/picker.dart';
import 'package:fox_fit/widgets/animated_container.dart';
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
  late GeneralController _controller;

  @override
  void initState() {
    super.initState();
    _scheduleController = Get.find<ScheduleController>();
    _controller = Get.find<GeneralController>();
    getAppointmentsDurations();
  }

  Future<void> getAppointmentsDurations() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: () {
        return _scheduleController.getAppointmentsDurations(
          userUid: _controller.getUid(
            role: UserRole.trainer,
          ),
        );
      },
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
          title: (_scheduleController.state.value.appointmentRecordType ==
                      AppointmentRecordType.view ||
                  _scheduleController.state.value.appointmentRecordType ==
                      AppointmentRecordType.groupView)
              ? S.of(context).train
              : S.of(context).sign_up_training_session,
          isNotification: false,
          isBackArrow: true,

          /// ???????????? ???????????????? ????????????????????
          action: (_scheduleController.state.value.appointmentRecordType ==
                      AppointmentRecordType.edit ||
                  _scheduleController.state.value.appointmentRecordType ==
                      AppointmentRecordType.view)
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
                          /// ?????????? ?????????????? ?????? ???????????????????????? ????????????????????
                          if (_isPersonal)
                            Obx(
                              () => CustomAnimatedContainer(
                                text: _scheduleController
                                        .state.value.clients.isNotEmpty
                                    ? _scheduleController
                                        .state.value.clients[0].model.fullName
                                    : S.of(context).select_client,
                                onTap: () {
                                  if (_scheduleController
                                          .state.value.appointmentRecordType !=
                                      AppointmentRecordType.view) {
                                    Get.toNamed(Routes.selectClient);
                                  }
                                },
                              ),
                            ),
                          if (_isPersonal) const SizedBox(height: 17),

                          /// ????????????????????????
                          Obx(
                            () => CustomAnimatedContainer(
                              text: _scheduleController.state.value.duration !=
                                      null
                                  ? '${_scheduleController.state.value.duration} ??????'
                                  : S.of(context).duration,
                              onTap: () async {
                                if (_isNotView) {
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
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 17),

                          /// ?????? ????????????????????
                          if (_isPersonal)
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  /// ????????????????????????
                                  Obx(() => CustomAnimatedContainer(
                                        text: S.of(context).personal,
                                        isActive: _scheduleController
                                                .state.value.split
                                            ? false
                                            : true,
                                        animation: AnimationModel(
                                            activeWidth: 148,
                                            inactiveWidth: 120),
                                        wrapText: false,
                                        onTap: () {
                                          if (_scheduleController.state.value
                                                  .appointmentRecordType !=
                                              AppointmentRecordType.view) {
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
                                          }
                                        },
                                      )),
                                  const SizedBox(width: 7),

                                  /// ??????????
                                  Obx(() => CustomAnimatedContainer(
                                        text: S.of(context).split,
                                        animation: AnimationModel(
                                          activeWidth: 80,
                                          inactiveWidth: 75,
                                        ),
                                        isActive: _scheduleController
                                                .state.value.split
                                            ? true
                                            : false,
                                        wrapText: false,
                                        onTap: () {
                                          if (_scheduleController.state.value
                                                  .appointmentRecordType !=
                                              AppointmentRecordType.view) {
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
                                          }
                                        },
                                      )),
                                ],
                              ),
                            ),
                          if (_isPersonal) const SizedBox(height: 17),

                          /// ????????????
                          Obx(() => CustomAnimatedContainer(
                                text: _scheduleController
                                        .state.value.service?.name ??
                                    S.of(context).service,
                                onTap: () {
                                  if (_isNotView) {
                                    if (_scheduleController.state.value
                                            .appointmentRecordType !=
                                        AppointmentRecordType.group) {
                                      if (_scheduleController
                                              .state.value.duration !=
                                          null) {
                                        Get.toNamed(Routes.selectService);
                                      } else {
                                        CustomSnackbar.getSnackbar(
                                          title: S
                                              .of(context)
                                              .fill_previous_fields,
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
                                  }
                                },
                              )),
                          const SizedBox(height: 17),

                          /// ???????? ????????????????????
                          Obx(
                            () {
                              /// ???????????????????????????? ???????? ?? ???????????? ????????????
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

                              return CustomAnimatedContainer(
                                text: dateEvent ?? S.of(context).date_event,
                                onTap: () async {
                                  if (_isNotView) {
                                    if (_scheduleController.state.value
                                            .appointmentRecordType !=
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
                                            doneStyle: theme
                                                .primaryTextTheme.headline2!,
                                            itemStyle:
                                                theme.textTheme.headline2!,
                                            backgroundColor:
                                                theme.backgroundColor,
                                            headerColor: theme.backgroundColor,
                                          ),
                                        );
                                      } else {
                                        CustomSnackbar.getSnackbar(
                                          title: S
                                              .of(context)
                                              .fill_previous_fields,
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
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 17),

                          /// ?????????? ????????????????????
                          Obx(
                            () {
                              /// ???????????????????????????? ?????????????? ?? ???????????? ????????????
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
                              return CustomAnimatedContainer(
                                text: selectedTime != null
                                    ? 'c $timeEventStart ???? $timeEventEnd'
                                    : S.of(context).time_lesson,
                                onTap: () async {
                                  if (_isNotView) {
                                    if (_scheduleController.state.value
                                            .appointmentRecordType !=
                                        AppointmentRecordType.group) {
                                      if (_scheduleController
                                                  .state.value.date !=
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
                                          valueStyle:
                                              theme.textTheme.headline2!,
                                          doneButtonColor:
                                              theme.colorScheme.primary,
                                          borderRadius: BorderRadius.zero,
                                        );
                                      } else {
                                        CustomSnackbar.getSnackbar(
                                          title: S
                                              .of(context)
                                              .fill_previous_fields,
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
                                  }
                                },
                              );
                            },
                          ),
                          if (_isGroup) const SizedBox(height: 17),

                          /// ?????????? ?????????????? ?????? ?????????????????? ????????????????????
                          if (_isGroup)
                            Obx(
                              () => ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _scheduleController
                                            .state.value.clients.length ==
                                        _scheduleController.state.value.capacity
                                    ? _scheduleController.state.value.capacity
                                    : _scheduleController
                                            .state.value.clients.length +
                                        1,
                                itemBuilder: (context, index) {
                                  /// ?????? ?????????????? ????????????
                                  PaymentStatusType? paymentStatus;
                                  if (index !=
                                      _scheduleController
                                          .state.value.clients.length) {
                                    var strStatus = _scheduleController
                                        .state
                                        .value
                                        .currentAppointment
                                        ?.arrivalStatuses
                                        .where((element) =>
                                            element.customerUid ==
                                            _scheduleController.state.value
                                                .clients[index].model.uid);
                                    if (strStatus != null) {
                                      if (strStatus.isNotEmpty) {
                                        paymentStatus =
                                            Enums.getPaymentStatusType(
                                                paymentStatusString: strStatus
                                                    .first.paymentStatus);
                                      }
                                    }
                                  }

                                  /// ?????? ?????????????????????? ??????????????
                                  bool clientIsSelected = index !=
                                          _scheduleController
                                              .state.value.clients.length
                                      ? true
                                      : false;
                                  if (clientIsSelected &&
                                      !_scheduleController.state.value
                                          .clients[index].isCanceled) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 17.0),
                                      child: CustomAnimatedContainer(
                                        isButtonDelete: _scheduleController
                                                    .state
                                                    .value
                                                    .appointmentRecordType !=
                                                AppointmentRecordType.groupView
                                            ? true
                                            : false,
                                        paymentStatusType: paymentStatus,
                                        arrivalStatus: _scheduleController.state
                                            .value.clients[index].arrivalStatus,
                                        text: _scheduleController.state.value
                                            .clients[index].model.fullName,
                                        onTap: () {},
                                        onDelete: () {
                                          _scheduleController.state
                                              .update((model) {
                                            model?.clients[index].isCanceled =
                                                true;
                                          });
                                        },
                                      ),
                                    );
                                  } else if (!clientIsSelected &&
                                      _scheduleController.state.value
                                              .appointmentRecordType !=
                                          AppointmentRecordType.groupView) {
                                    return CustomAnimatedContainer(
                                      text: S.of(context).select_client,
                                      onTap: () async {
                                        Get.toNamed(Routes.selectClient);
                                      },
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
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
            ? (_isNotView)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: CustomTextButton(
                      height: 51,
                      text: buttonText,
                      backgroundColor: theme.colorScheme.secondary,
                      textStyle: theme.textTheme.button!,
                      onTap: () {
                        if (validateFields()) {
                          String dataTimeString =
                              '${DateFormat('d.MM.yy').format(_scheduleController.state.value.date!)} ?? '
                              '${DateFormat('HH:mm').format(_scheduleController.state.value.time!)}';
                          Get.to(
                            () => ConfirmationPage(
                              textButtonDone: buttonText,
                              textButtonCancel: S.of(context).back,
                              richText: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${S.of(context).record}\n',
                                      style: theme.textTheme.headline5,
                                    ),
                                    if (_scheduleController.state.value
                                            .appointmentRecordType !=
                                        AppointmentRecordType.group)
                                      TextSpan(
                                        text:
                                            '${_scheduleController.state.value.clients[0].model.fullName}\n',
                                        style:
                                            theme.textTheme.headline6!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    if (_scheduleController.state.value
                                            .appointmentRecordType ==
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
                : null
            : null,
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

  /// ?????????? ?????????? ????????????
  String get buttonText {
    if (_scheduleController.state.value.appointmentRecordType ==
            AppointmentRecordType.edit ||
        _scheduleController.state.value.appointmentRecordType ==
            AppointmentRecordType.group) {
      return S.of(context).save;
    } else {
      return S.of(context).record;
    }
  }

  /// ???????? ????????????????????????
  bool get _isPersonal {
    return _scheduleController.state.value.appointmentRecordType !=
            AppointmentRecordType.group &&
        _scheduleController.state.value.appointmentRecordType !=
            AppointmentRecordType.groupView;
  }

  /// ???????? ??????????????????
  bool get _isGroup {
    return _scheduleController.state.value.appointmentRecordType ==
            AppointmentRecordType.group ||
        _scheduleController.state.value.appointmentRecordType ==
            AppointmentRecordType.groupView;
  }

  /// ???????? ???? ????????????????
  bool get _isNotView {
    return _scheduleController.state.value.appointmentRecordType !=
            AppointmentRecordType.view &&
        _scheduleController.state.value.appointmentRecordType !=
            AppointmentRecordType.groupView;
  }
}
