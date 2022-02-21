import 'package:flutter/material.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_client.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_service.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/picker/picker.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';

class SignUpTrainingSessionPage extends StatefulWidget {
  const SignUpTrainingSessionPage({Key? key}) : super(key: key);

  @override
  _SignUpTrainingSessionPageState createState() =>
      _SignUpTrainingSessionPageState();
}

class _SignUpTrainingSessionPageState extends State<SignUpTrainingSessionPage> {
  late bool _isLoading;
  late ScheduleController _scheduleController;
  String? _service;
  String? _date;
  String? _time;

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

    await ErrorHandler.loadingData(
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
        onBack: () {
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
                                  animation: Animation(activeWidth: 144),
                                  type: TrainingType.personal,
                                  onTap: () {
                                    if (_scheduleController
                                            .scheduleState.value.duration !=
                                        null) {
                                      _scheduleController.scheduleState
                                          .update((model) {
                                        model?.type = TrainingType.personal;
                                      });
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
                                  animation: Animation(
                                      activeWidth: 77, inactiveWidth: 60),
                                  type: TrainingType.group,
                                  onTap: () {
                                    if (_scheduleController
                                            .scheduleState.value.duration !=
                                        null) {
                                      _scheduleController.scheduleState
                                          .update((model) {
                                        model?.type = TrainingType.group;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 17),

                        /// Услуга
                        _buildContainer(
                          context: context,
                          theme: theme,
                          text: S.of(context).service,
                          onTap: () {
                            if (_scheduleController
                                    .scheduleState.value.duration !=
                                null) {
                              Get.to(
                                () => SelectServicePage(
                                  callBack: (String? service) {
                                    setState(() {
                                      _service = service;
                                    });
                                  },
                                ),
                                transition: Transition.fadeIn,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 17),

                        /// Дата проведения
                        _buildContainer(
                          context: context,
                          theme: theme,
                          text: S.of(context).date_event,
                          onTap: () {},
                        ),
                        const SizedBox(height: 17),

                        /// Время проведения
                        _buildContainer(
                          context: context,
                          theme: theme,
                          text: S.of(context).time_lesson,
                          onTap: () {},
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
                onTap: () {},
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
    Animation? animation,
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
        width: animation != null
            ? type == _scheduleController.scheduleState.value.type
                ? animation.activeWidth
                : animation.inactiveWidth
            : width ?? MediaQuery.of(context).size.width,
        height: animation != null
            ? type == _scheduleController.scheduleState.value.type
                ? animation.activeHeight
                : animation.inactiveHeight
            : null,
        decoration: BoxDecoration(
          border: animation != null
              ? type == _scheduleController.scheduleState.value.type
                  ? Border.all(color: theme.colorScheme.secondary)
                  : null
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DefaultContainer(
          height: animation != null ? null : 60,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 11),
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
      ),
    );
  }
}

class Animation {
  Animation({
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
