import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
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
    required this.image,
    this.text = '',
    this.richText,
    this.textButton,
    this.padding = const EdgeInsets.fromLTRB(20, 150, 20, 20),
  }) : super(key: key);

  final StagePipelineType stagePipelineType;
  final String image;
  final String text;
  final RichText? richText;
  final String? textButton;
  final EdgeInsetsGeometry padding;

  final TextEditingController textController = TextEditingController();

  final GeneralController controller = Get.find<GeneralController>();

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
                    image,
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
                      if (controller.appState.value.isCanVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }
                      _requestConfirm(theme: theme, context: context);
                    },
                    text: textButton ?? S.of(context).confirm,
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
                      text: S.of(context).cancel,
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
      dynamic data = await ErrorHandler.singleRequest(
        context: context,
        request: () {
          return controller.transferClientToTrainer(
            userUid: controller.appState.value.auth!.users![1].uid,
            customerUid: controller.appState.value.currentCustomer!.uid,
            trainerUid: controller.appState.value.currentTrainer!.uid,
          );
        },
        handler: (_) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).server_error,
            message: S.of(context).confirmation_failed,
          );
        },
      );

      if (data == 200) {
        controller.appState.update((model) {
          model?.currentCustomer = null;
          model?.currentTrainer = null;
        });

        await controller.getTrainers();

        Get.back();
        Get.back();
        Get.back();

        ErrorHandler.singleRequest(
          context: context,
          request: controller.getCustomers,
          skipCheck: true,
        );
        await ErrorHandler.singleRequest(
          context: context,
          request: controller.getCoordinaorWorkSpace,
          skipCheck: true,
          handler: (_) {
            CustomSnackbar.getSnackbar(
              title: S.of(context).no_internet_access,
              message: S.of(context).failed_update_list,
            );
          },
        );
      }

      /// Если относится к стадии [Назначено]
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
    dynamic data = await ErrorHandler.singleRequest(
      context: context,
      request: () {
        return controller.transferClientByTrainerPipeline(
          userUid: controller.appState.value.auth!.users![0].uid,
          customerUid: controller.appState.value.currentCustomer!.uid,
          trainerPipelineStageUid: Enums.getStagePipelineUid(
            stagePipelineType: stagePipelineType,
          ),
          transferDate: transferDate,
          commentText: textController.text,
        );
      },
      handler: (dynamic data) {
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
      controller.appState.update((model) {
        model?.currentCustomer = null;
      });

      Get.back();
      Get.back();
      Get.back();

      await ErrorHandler.singleRequest(
        context: context,
        request: controller.getCustomers,
        skipCheck: true,
        handler: (_) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).no_internet_access,
            message: S.of(context).failed_update_list,
          );
        },
      );
    }
  }
}
