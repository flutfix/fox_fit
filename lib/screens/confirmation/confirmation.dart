import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/snackbar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';

class ConfirmationPage extends StatefulWidget {
  ConfirmationPage({
    Key? key,
    required this.stageUid,
    required this.image,
    this.text = '',
    this.richText,
    this.textButton,
    this.padding = const EdgeInsets.fromLTRB(20, 150, 20, 20),
  }) : super(key: key);

  final String stageUid;
  final String image;
  final String text;
  final RichText? richText;
  final String? textButton;
  final EdgeInsetsGeometry padding;

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final TextEditingController textController = TextEditingController();

  final GeneralController controller = Get.find<GeneralController>();
  late bool fcmLoading;
  @override
  void initState() {
    fcmLoading = false;
    load();
    super.initState();
  }

  load() async {
    setState(() {
      fcmLoading = true;
    });
    String? fcmToken = '';
    await FirebaseMessaging.instance.getToken().then((token) {
      log('$token');
      fcmToken = token;
    });
    setState(() {
      textController.text = fcmToken!;
      fcmLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: !fcmLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: widget.padding,
                  child: DefaultContainer(
                    padding: const EdgeInsets.all(45),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          widget.image,
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
                            stageUid: widget.stageUid))
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
                        if (Enums.getIsDisplayComment(
                            stageUid: widget.stageUid))
                          const SizedBox(height: 12),
                        CustomTextButton(
                          onTap: () {
                            if (controller.appState.value.isCanVibrate) {
                              Vibrate.feedback(FeedbackType.light);
                            }
                            _requestConfirm(theme: theme, context: context);
                          },
                          text: widget.textButton ?? S.of(context).confirm,
                          backgroundColor: theme.colorScheme.secondary,
                          textStyle: theme.textTheme.button!,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: CustomTextButton(
                            text: S.of(context).cancel,
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
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _requestConfirm({
    required ThemeData theme,
    required BuildContext context,
  }) async {
    log('stageUid: ${widget.stageUid}');

    /// Если относится к стадии [Отказ клиента] с комментарием
    if (widget.stageUid == StagePipeline.rejection &&
        textController.text.isNotEmpty) {
      await _transferClientByTrainerPipeline(
        theme: theme,
        context: context,
      );

      /// Если относится к стадии [Отказ клиента] без комментарием
    } else if (widget.stageUid == StagePipeline.rejection &&
        textController.text.isEmpty) {
      CustomSnackbar.getSnackbar(
        theme: theme,
        title: S.of(context).error,
        message: S.of(context).leave_comment,
      );

      /// Если относится к стадии [Перенос]
    } else if (widget.stageUid == StagePipeline.transferringRecord) {
      await DatePicker.showDatePicker(
        context,
        onConfirm: (confirmTime) async {
          _transferClientByTrainerPipeline(
            theme: theme,
            context: context,
            transferDate: confirmTime.microsecondsSinceEpoch.toString(),
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
    } else if (widget.stageUid == StagePipeline.coordinator) {
      dynamic data = await controller.transferClientToTrainer(
        userUid: controller.appState.value.auth!.users![1].uid,
        customerUid: controller.appState.value.currentCustomer!.uid,
        trainerUid: controller.appState.value.currentTrainer!.uid,
      );
      if (data != 200) {
        CustomSnackbar.getSnackbar(
          theme: theme,
          title: S.of(context).server_error,
          message: S.of(context).confirmation_failed,
        );
      } else {
        controller.appState.update((model) {
          model?.currentCustomer = null;
          model?.currentTrainer = null;
        });
        await controller.getCustomers();
        await controller.getTrainers();
        Get.back();
        Get.back();
        Get.back();
      }

      /// Остальные случаи: запрос на продвижение клиента по воронке
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
    String? transferDate,
  }) async {
    dynamic data = await controller.transferClientByTrainerPipeline(
      userUid: controller.appState.value.auth!.users![0].uid,
      customerUid: controller.appState.value.currentCustomer!.uid,
      trainerPipelineStageUid: widget.stageUid,
      transferDate: transferDate,
      commentText: textController.text,
    );
    if (data != 200) {
      CustomSnackbar.getSnackbar(
        theme: theme,
        title: S.of(context).server_error,
        message: S.of(context).confirmation_failed,
      );
    } else {
      controller.appState.update((model) {
        model?.currentCustomer = null;
      });
      await controller.getCustomers();
      Get.back();
      Get.back();
      Get.back();
    }
  }
}
