import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_client.dart';
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
  String? _currentClient;
  String? _currentDuration;
  String? _currentType;
  String? _currentService;
  String? _currentDate;
  String? _currentTime;

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Выбор клиента
                  _buildContainer(
                    context: context,
                    theme: theme,
                    text: _currentClient ?? S.of(context).select_client,
                    onTap: () {
                      Get.to(
                        () => SelectClientPage(
                          callBack: (String? client) {
                            setState(() {
                              _currentClient = client;
                            });
                          },
                        ),
                        transition: Transition.fadeIn,
                      );
                    },
                  ),
                  const SizedBox(height: 17),

                  /// Длительность
                  _buildContainer(
                    context: context,
                    theme: theme,
                    text: S.of(context).duration,
                    onTap: () {},
                  ),
                  const SizedBox(height: 17),

                  /// Вид тренировки
                  Row(
                    children: [
                      /// Персональная
                      _buildContainer(
                        context: context,
                        theme: theme,
                        text: S.of(context).personal,
                        width: 144,
                        onTap: () {
                          setState(() {
                            _currentType = 'Personal';
                          });
                        },
                      ),
                      const SizedBox(width: 7),

                      /// Сплит
                      _buildContainer(
                        context: context,
                        theme: theme,
                        text: S.of(context).split,
                        width: 77,
                        onTap: () {
                          setState(() {
                            _currentType = 'Group';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),

                  /// Услуга
                  _buildContainer(
                    context: context,
                    theme: theme,
                    text: S.of(context).service,
                    onTap: () {},
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: CustomTextButton(
          onTap: () {
            // Get.toNamed(Routes.signUpTrainingSession);
          },
          height: 51,
          text: S.of(context).record,
          backgroundColor: theme.colorScheme.secondary,
          textStyle: theme.textTheme.button!,
        ),
      ),
    );
  }

  Widget _buildContainer({
    required BuildContext context,
    required ThemeData theme,
    required String text,
    required Function() onTap,
    double? width,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: DefaultContainer(
        width: width ?? MediaQuery.of(context).size.width,
        child: Text(
          text,
          style: theme.textTheme.bodyText1,
        ),
      ),
    );
  }
}
