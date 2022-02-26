import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/utils/date_time_picker/date_time_picker.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/date_time_picker_theme.dart';
import 'package:fox_fit/utils/date_time_picker/widgets/i18n_model.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';

class ConfirmationPage extends StatelessWidget {
  ConfirmationPage({
    Key? key,
    required this.stagePipelineType,
    this.trainingRecordType,
    this.text = '',
    this.richText,
    this.textButtonDone,
    this.textButtonCancel,
    this.padding = const EdgeInsets.fromLTRB(20, 150, 20, 20),
  }) : super(key: key);

  final StagePipelineType stagePipelineType;
  final TrainingRecordType? trainingRecordType;
  final String text;
  final RichText? richText;
  final String? textButtonDone;
  final String? textButtonCancel;
  final EdgeInsetsGeometry padding;

  final TextEditingController textController = TextEditingController();

  final GeneralController _generalController = Get.find<GeneralController>();
  final ScheduleController _scheduleController = Get.find<ScheduleController>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: padding,
            child: DefaultContainer(
              padding: const EdgeInsets.all(45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Enums.getIconStage(
                      stageType: stagePipelineType,
                    ),
                    width: 42,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 30),
                  if (richText != null)
                    richText!
                  else
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline5,
                    ),
                  const SizedBox(height: 12),
                  if (Enums.getIsDisplayComment(stageType: stagePipelineType))
                    Input(
                      textController: textController,
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
                  if (Enums.getIsDisplayComment(stageType: stagePipelineType))
                    const SizedBox(height: 12),
                  CustomTextButton(
                    onTap: () {
                      if (_generalController.appState.value.isCanVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }
                      _requestConfirm(theme: theme, context: context);
                    },
                    text: textButtonDone ?? S.of(context).confirm,
                    backgroundColor: theme.colorScheme.secondary,
                    textStyle: theme.textTheme.button!,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      if (stagePipelineType ==
                          StagePipelineType.transferringRecord) {
                        Get.back();
                      }
                    },
                    child: CustomTextButton(
                      text: textButtonCancel ?? S.of(context).cancel,
                      backgroundColor: theme.buttonTheme.colorScheme!.primary,
                      textStyle: theme.textTheme.button!.copyWith(
                          color: theme.buttonTheme.colorScheme!.secondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestConfirm({
    required ThemeData theme,
    required BuildContext context,
  }) async {
    /// Если относится к стадии [Отказ] или [Недозвон]
    if (stagePipelineType == StagePipelineType.rejection ||
        stagePipelineType == StagePipelineType.nonCall) {
      /// С комментарием
      if (textController.text.isNotEmpty) {
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
    } else if (stagePipelineType == StagePipelineType.transferringRecord) {
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
    } else if (stagePipelineType == StagePipelineType.coordinator) {
      dynamic data = await ErrorHandler.request(
        repeat: false,
        context: context,
        request: () {
          return _generalController.transferClientToTrainer(
            userUid: _generalController.appState.value.auth!.users![1].uid,
            customerUid: _generalController.appState.value.currentCustomer!.uid,
            trainerUid: _generalController.appState.value.currentTrainer!.uid,
          );
        },
        handler: (_) async {
          CustomSnackbar.getSnackbar(
            title: S.of(context).server_error,
            message: S.of(context).confirmation_failed,
          );
        },
      );

      if (data == 200) {
        _generalController.appState.update((model) {
          model?.currentCustomer = null;
          model?.currentTrainer = null;
        });

        await _generalController.getTrainers();

        Get.back();
        Get.back();
        Get.back();

        ErrorHandler.request(
          context: context,
          request: _generalController.getCustomers,
          repeat: false,
          skipCheck: true,
        );
        await ErrorHandler.request(
          context: context,
          request: _generalController.getCoordinaorWorkSpace,
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

      /// Если относится к стадии [Занятие]
    } else if (stagePipelineType == StagePipelineType.training) {
      String appointmentType = Enums.getTrainingTypeString(
        trainingType: _scheduleController.state.value.type,
      );

      /// Преобразование даты и времени в единый timestamp
      String dateTimeAppointment = DateTime(
        _scheduleController.state.value.date!.year,
        _scheduleController.state.value.date!.month,
        _scheduleController.state.value.date!.day,
        _scheduleController.state.value.time!.hour,
        _scheduleController.state.value.time!.minute,
      ).millisecondsSinceEpoch.toString().substring(0, 10);

      if (trainingRecordType == TrainingRecordType.create) {
        dynamic data = await ErrorHandler.request(
          context: context,
          repeat: false,
          request: () async {
            return _scheduleController.addAppointment(
              licenseKey:
                  _generalController.appState.value.auth!.data!.licenseKey,
              userUid: _generalController.appState.value.auth!.users![0].uid,
              customers: _scheduleController.state.value.clients!,
              appointmentType: appointmentType,
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

        if (data == 200) {
          _scheduleController.clear(appointment: true);
          Get.offNamed(Routes.schedule);
        }
      } else if (trainingRecordType == TrainingRecordType.revoke) {
        dynamic data = await ErrorHandler.request(
          context: context,
          repeat: false,
          request: () {
            return _scheduleController.deleteAppointment(
              licenseKey:
                  _generalController.appState.value.auth!.data!.licenseKey,
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

        if (data == 200) {
          _scheduleController.clear(appointment: true);
          Get.offNamed(Routes.schedule);
        }
      } else {
        dynamic data = await ErrorHandler.request(
          context: context,
          repeat: false,
          request: () async {
            return _scheduleController.editAppointment(
              licenseKey:
                  _generalController.appState.value.auth!.data!.licenseKey,
              userUid: _generalController.appState.value.auth!.users![0].uid,
              customers: _scheduleController.state.value.clients!,
              appointmentUid:
                  _scheduleController.state.value.appointment!.appointmentUid,
              appointmentType: appointmentType,
              dateTimeAppointment: dateTimeAppointment,
              serviceUid: _scheduleController.state.value.service!.uid,
            );
          },
          handler: (data) async {
            if (data == 403) {
              CustomSnackbar.getSnackbar(
                title: S.of(context).error,
                message: S.of(context).valid_license_not_found,
              );
            }
          },
        );

        if (data == 200) {
          _scheduleController.clear(appointment: true);
          Get.offNamed(Routes.schedule);
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
    dynamic data = await ErrorHandler.request(
      context: context,
      repeat: false,
      request: () {
        return _generalController.transferClientByTrainerPipeline(
          userUid: _generalController.appState.value.auth!.users![0].uid,
          customerUid: _generalController.appState.value.currentCustomer!.uid,
          trainerPipelineStageUid: Enums.getStagePipelineUid(
            stagePipelineType: stagePipelineType,
          ),
          transferDate: transferDate,
          commentText: textController.text,
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

    if (data == 200) {
      _generalController.appState.update((model) {
        model?.currentCustomer = null;
      });

      Get.back();
      Get.back();
      Get.back();

      await ErrorHandler.request(
        context: context,
        request: _generalController.getCustomers,
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
