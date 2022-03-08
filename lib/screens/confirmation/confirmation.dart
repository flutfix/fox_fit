import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/sales_controller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/screens/customers/widgets/blur.dart';
import 'package:fox_fit/utils/date_time_picker/date_time_picker.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/date_time_picker_theme.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/i18n_model.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({
    Key? key,
    this.stagePipelineType = StagePipelineType.appointment,
    this.text = '',
    this.richText,
    this.textButtonDone,
    this.textButtonCancel,
    this.padding = const EdgeInsets.fromLTRB(20, 150, 20, 20),
  }) : super(key: key);

  final StagePipelineType stagePipelineType;
  final String text;
  final RichText? richText;
  final String? textButtonDone;
  final String? textButtonCancel;
  final EdgeInsetsGeometry padding;

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late bool _isLoading;
  late final TextEditingController _textController;
  late final GeneralController _controller;
  late final ScheduleController _scheduleController;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _textController = TextEditingController();
    _controller = Get.find<GeneralController>();
    _scheduleController = Get.find<ScheduleController>();
  }

  Future<dynamic> load({required Future Function() function}) async {
    setState(() {
      _isLoading = true;
    });

    dynamic data = await function();

    setState(() {
      _isLoading = false;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () {
        Get.back();
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: theme.backgroundColor,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: widget.padding,
                  child: DefaultContainer(
                    padding: const EdgeInsets.all(45),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Enums.getIconStage(
                            stageType: widget.stagePipelineType,
                          ),
                          width: 42,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 30),
                        if (widget.richText != null)
                          widget.richText!
                        else
                          Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline5,
                          ),
                        const SizedBox(height: 12),
                        if (Enums.getIsDisplayComment(
                            stageType: widget.stagePipelineType))
                          Input(
                            textController: _textController,
                            hintText: S.of(context).comment_for_recipient,
                            hintStyle: theme.textTheme.bodyText2,
                            textStyle: theme.textTheme.bodyText2,
                            cursorColor: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                            padding: const EdgeInsets.all(5),
                            textCapitalization: TextCapitalization.sentences,
                            lines: 3,
                          )
                        else
                          const SizedBox(height: 50),
                        if (Enums.getIsDisplayComment(
                            stageType: widget.stagePipelineType))
                          const SizedBox(height: 12),
                        CustomTextButton(
                          onTap: () {
                            if (_controller.appState.value.isCanVibrate) {
                              Vibrate.feedback(FeedbackType.light);
                            }
                            _requestConfirm(theme: theme, context: context);
                          },
                          text: widget.textButtonDone ?? S.of(context).confirm,
                          backgroundColor: theme.colorScheme.secondary,
                          textStyle: theme.textTheme.button!,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            if (_scheduleController
                                    .state.value.appointmentRecordType ==
                                AppointmentRecordType.revoke) {
                              _scheduleController.state.update((model) {
                                model?.appointmentRecordType =
                                    AppointmentRecordType.edit;
                              });
                            }
                            Get.back();
                            if (widget.stagePipelineType ==
                                StagePipelineType.transferringRecord) {
                              Get.back();
                            }
                          },
                          child: CustomTextButton(
                            text:
                                widget.textButtonCancel ?? S.of(context).cancel,
                            backgroundColor:
                                theme.buttonTheme.colorScheme!.primary,
                            textStyle: theme.textTheme.button!.copyWith(
                                color:
                                    theme.buttonTheme.colorScheme!.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading) BlurryEffect(0.1, 3, Colors.white),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _requestConfirm({
    required ThemeData theme,
    required BuildContext context,
  }) async {
    /// Если относится к стадии [Отказ] или [Недозвон]
    if (widget.stagePipelineType == StagePipelineType.rejection ||
        widget.stagePipelineType == StagePipelineType.nonCall) {
      /// С комментарием
      if (_textController.text.isNotEmpty) {
        await _transferClientByTrainerPipeline(
          theme: theme,
          context: context,
        );

        /// Без комментария
      } else {
        CustomSnackbar.getSnackbar(
          title: S.of(context).error,
          message: S.of(context).leave_comment,
        );
      }

      /// Если относится к стадии [Перенос]
    } else if (widget.stagePipelineType ==
        StagePipelineType.transferringRecord) {
      await DatePicker.showDatePicker(
        context,
        onConfirm: (confirmTime) async {
          _transferClientByTrainerPipeline(
            theme: theme,
            context: context,
            transferDate:
                confirmTime.millisecondsSinceEpoch.toString().substring(0, 10),
            isTransferringRecord: true,
          );
        },
        minTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        ),
        locale: LocaleType.ru,
        currentTime: DateTime.now(),
        theme: DatePickerTheme(
          cancelStyle: theme.textTheme.headline2!,
          doneStyle: theme.primaryTextTheme.headline2!,
          itemStyle: theme.textTheme.headline2!,
          backgroundColor: theme.backgroundColor,
          headerColor: theme.backgroundColor,
        ),
      );

      /// Если было открыто от роли [Координатор]
    } else if (widget.stagePipelineType == StagePipelineType.coordinator) {
      dynamic data = await load(function: () {
        return ErrorHandler.request(
          repeat: false,
          context: context,
          request: () {
            return _controller.transferClientToTrainer(
              userUid: _controller.getUid(role: UserRole.coordinator),
              customerUid: _controller.appState.value.currentCustomer!.uid,
              trainerUid: _controller.appState.value.currentTrainer!.uid,
            );
          },
          handler: (_) async {
            CustomSnackbar.getSnackbar(
              title: S.of(context).server_error,
              message: S.of(context).confirmation_failed,
            );
          },
        );
      });

      if (data == 200) {
        _controller.appState.update((model) {
          model?.currentCustomer = null;
          model?.currentTrainer = null;
        });

        await _controller.getTrainers();

        Get.back();
        Get.back();
        Get.back();

        ErrorHandler.request(
          context: context,
          request: _controller.getCustomers,
          repeat: false,
          skipCheck: true,
        );
        await ErrorHandler.request(
          context: context,
          request: _controller.getCoordinaorWorkSpace,
          repeat: false,
          skipCheck: true,
          handler: (_) async {
            CustomSnackbar.getSnackbar(
              title: S.of(context).no_internet_access,
              message: S.of(context).failed_update_list,
            );
          },
        );
      }
    } else if (widget.stagePipelineType == StagePipelineType.sale) {
      SalesController _salesController = Get.find<SalesController>();
      dynamic data = await load(function: () {
        return ErrorHandler.request(
          context: context,
          repeat: false,
          request: () async {
            return _salesController.addSale(
              userUid: _controller.getUid(role: UserRole.trainer),
            );
          },
          handler: (data) async {
            if (data == 403) {
              CustomSnackbar.getSnackbar(
                title: S.of(context).error,
                message: S.of(context).valid_license_not_found,
              );
            } else {
              CustomSnackbar.getSnackbar(
                title: S.of(context).server_error,
                message: S.of(context).add_sale_failed,
              );
            }
          },
        );
      });

      if (data == 200) {
        Get.back();
        Get.back();
      }

      /// Если относится к стадии [Тренировка]
    } else if (widget.stagePipelineType == StagePipelineType.appointment) {
      /// Преобразование даты и времени в единый timestamp
      String dateTimeAppointment = DateTime(
        _scheduleController.state.value.date!.year,
        _scheduleController.state.value.date!.month,
        _scheduleController.state.value.date!.day,
        _scheduleController.state.value.time!.hour,
        _scheduleController.state.value.time!.minute,
      ).millisecondsSinceEpoch.toString().substring(0, 10);

      /// Создание тренировки
      if (_scheduleController.state.value.appointmentRecordType ==
          AppointmentRecordType.create) {
        dynamic data = await load(function: () {
          return ErrorHandler.request(
            context: context,
            repeat: false,
            request: () async {
              return _scheduleController.addAppointment(
                licenseKey: _controller.appState.value.auth!.data!.licenseKey,
                userUid: _controller.getUid(role: UserRole.trainer),
                customers: _scheduleController.state.value.clients,
                appointmentType: Enums.getAppointmentTypeString(
                  appointmentType: AppointmentType.personal,
                ),
                split: _scheduleController.state.value.split,
                dateTimeAppointment: dateTimeAppointment,
                serviceUid: _scheduleController.state.value.service!.uid,
                capacity: 1,
              );
            },
            handler: (data) async {
              if (data == 403) {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).error,
                  message: S.of(context).valid_license_not_found,
                );
              } else {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).server_error,
                  message: S.of(context).trining_could_not_recorded,
                );
              }
            },
          );
        });

        if (data == 200) {
          Get.back();
          Get.back();
          Get.back();
          Get.toNamed(Routes.schedule);
        }

        /// Удаление тренировки
      } else if (_scheduleController.state.value.appointmentRecordType ==
          AppointmentRecordType.revoke) {
        dynamic data = await load(function: () {
          return ErrorHandler.request(
            context: context,
            repeat: false,
            request: () {
              return _scheduleController.deleteAppointment(
                licenseKey: _controller.appState.value.auth!.data!.licenseKey,
                appointmentUid:
                    _scheduleController.state.value.appointment!.appointmentUid,
              );
            },
            handler: (data) async {
              if (data != 200) {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).server_error,
                  message: S.of(context).activity_could_not_deleted,
                );
              }
            },
          );
        });

        if (data == 200) {
          Get.back();
          Get.back();
          Get.back();
          Get.toNamed(Routes.schedule);
        }

        /// Редактирование тренировки
      } else {
        dynamic data = await load(function: () {
          return ErrorHandler.request(
            context: context,
            repeat: false,
            request: () async {
              return _scheduleController.editAppointment(
                licenseKey: _controller.appState.value.auth!.data!.licenseKey,
                userUid: _controller.getUid(role: UserRole.trainer),
                customers: _scheduleController.state.value.clients,
                appointmentUid:
                    _scheduleController.state.value.appointment!.appointmentUid,
                appointmentType: Enums.getAppointmentTypeString(
                  appointmentType:
                      _scheduleController.state.value.appointmentRecordType ==
                              AppointmentRecordType.edit
                          ? AppointmentType.personal
                          : AppointmentType.group,
                ),
                split: _scheduleController.state.value.appointmentRecordType ==
                        AppointmentRecordType.edit
                    ? _scheduleController.state.value.split
                    : null,
                dateTimeAppointment: dateTimeAppointment,
                serviceUid: _scheduleController.state.value.service!.uid,
              );
            },
            handler: (data) async {
              if (data == 401) {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).error,
                  message: S.of(context).appointment_has_already_been_held,
                );
              } else if (data == 403) {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).error,
                  message: S.of(context).valid_license_not_found,
                );
              }
            },
          );
        });

        if (data == 200) {
          Get.back();
          Get.back();
          Get.back();
          Get.toNamed(Routes.schedule);
        }
      }
    } else {
      _transferClientByTrainerPipeline(
        theme: theme,
        context: context,
      );
    }
  }

  /// Запрос на продвижение клиента по воронке
  Future<void> _transferClientByTrainerPipeline({
    required ThemeData theme,
    required BuildContext context,
    bool isTransferringRecord = false,
    String? transferDate,
  }) async {
    dynamic data = await load(function: () {
      return ErrorHandler.request(
        context: context,
        repeat: false,
        request: () {
          return _controller.transferClientByTrainerPipeline(
            userUid: _controller.getUid(role: UserRole.trainer),
            customerUid: _controller.appState.value.currentCustomer!.uid,
            trainerPipelineStageUid: Enums.getStagePipelineUid(
              stagePipelineType: widget.stagePipelineType,
            ),
            transferDate: transferDate,
            commentText: _textController.text,
          );
        },
        handler: (dynamic data) async {
          if (isTransferringRecord) {
            if (data == 400) {
              CustomSnackbar.getSnackbar(
                duration: 5,
                title: S.of(context).error,
                message: S.of(context).error_transferring_record,
              );
            }
          } else {
            CustomSnackbar.getSnackbar(
              title: S.of(context).server_error,
              message: S.of(context).confirmation_failed,
            );
          }
        },
      );
    });

    if (data == 200) {
      _controller.appState.update((model) {
        model?.currentCustomer = null;
      });

      Get.back();
      Get.back();
      Get.back();

      await ErrorHandler.request(
        context: context,
        request: _controller.getCustomers,
        repeat: false,
        skipCheck: true,
        handler: (_) async {
          CustomSnackbar.getSnackbar(
            title: S.of(context).no_internet_access,
            message: S.of(context).failed_update_list,
          );
        },
      );
    }
  }
}
