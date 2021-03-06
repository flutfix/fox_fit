import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/more_card.dart';
import 'package:fox_fit/widgets/bottom_sheet.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late List<MoreCardModel> cards;
  late GeneralController _controller;
  
  @override
  void initState() {
    cards = [];

    _controller = Get.put(GeneralController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (cards.isEmpty) {
      setState(() {
        cards = [
          /// [Расписание]
          if (_controller.appState.value.useSchedule)
            MoreCardModel(
              text: S.of(context).schedule,
              icon: Images.schedule,
              onTap: () {
                Get.toNamed(Routes.schedule);
              },
            ),

          /// [Статистика тренера]
          MoreCardModel(
            text: S.of(context).trainer_stats,
            icon: Images.trainerStats,
            onTap: () {
              Get.toNamed(Routes.trainerStats);
            },
          ),

          /// [Выставить продажу]
          if (_controller.appState.value.useSalesCoach)
            MoreCardModel(
              text: S.of(context).sales,
              icon: Images.sale,
              onTap: () {
                Get.toNamed(Routes.sale);
              },
            ),

          /// ["Спящие" клиенты]
          MoreCardModel(
            text: S.of(context).sleeping_customers,
            icon: Images.inactiveCustomers,
            onTap: () {
              Get.toNamed(Routes.sleepingCustomers);
            },
          ),

          /// [Поддержка]
          MoreCardModel(
            text: S.of(context).support,
            icon: Images.support,
            onTap: () async {
              String whatsapp =
                  'whatsapp://send?phone=${_controller.appState.value.auth!.data!.supportPhone}';
              whatsapp = Uri.encodeFull(whatsapp);
              if (await canLaunch(whatsapp)) {
                try {
                  launch(
                    whatsapp,
                    forceWebView: false,
                  );
                } catch (e) {
                  log(e.toString());
                }
              } else {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).whatsapp_exeption,
                );
              }
            },
          ),

          /// [Координатор]
          if (_controller.appState.value.isCoordinator)
            MoreCardModel(
              text: S.of(context).coordinator,
              icon: Images.coordinatorPng,
              onTap: () {
                Get.toNamed(Routes.coordinator);
              },
            ),

          /// [Смена пароля]
          MoreCardModel(
            text: S.of(context).change_password,
            icon: Images.passPng,
            onTap: () {
              Get.toNamed(Routes.changePassword);
            },
          ),

          /// [Обучение]
          MoreCardModel(
            text: S.of(context).training,
            icon: Images.trainingPng,
            onTap: () {
              Get.toNamed(Routes.training);
            },
          ),

          /// [Выйти из профиля]
          MoreCardModel(
            text: S.of(context).log_out,
            icon: Images.logOut,
            onTap: () {
              _showBottomSheet(
                context: context,
                theme: theme,
              );
            },
          ),
        ];
      });
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            ...List.generate(
              cards.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (index != cards.length - 1) ? 5.0 : 0.0),
                  child: _buildCard(
                    theme: theme,
                    text: cards[index].text,
                    icon: cards[index].icon,
                    iconSize:
                        cards[index].icon == Images.coordinatorPng ? 21 : 19,
                    onTap: cards[index].onTap,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required String text,
    required String icon,
    Function()? onTap,
    double iconSize = 19,
  }) {
    return DefaultContainer(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            icon,
            width: iconSize,
            color: theme.colorScheme.secondary,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  void _showBottomSheet({
    required BuildContext context,
    required ThemeData theme,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CustomBottomSheet(
          backgroundColor: theme.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 65,
              vertical: 50,
            ),
            child: Column(
              children: [
                SvgPicture.asset(Images.exit),
                const SizedBox(height: 32),
                Text(
                  '${S.of(context).log_out}?',
                  style: theme.textTheme.headline5,
                ),
                const SizedBox(height: 50),
                CustomTextButton(
                  onTap: () async {
                    if (_controller.appState.value.isCanVibrate) {
                      Vibrate.feedback(FeedbackType.light);
                    }
                    Get.delete<GeneralController>();
                    Get.delete<ScheduleController>();
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setBool(Cache.isAuthorized, false);
                    prefs.setString(Cache.pass, '');

                    Get.offAllNamed(Routes.auth);
                  },
                  text: S.of(context).exit,
                  backgroundColor: theme.colorScheme.secondary,
                  textStyle: theme.textTheme.button!,
                ),
                const SizedBox(height: 12),
                CustomTextButton(
                  onTap: () {
                    Get.back();
                  },
                  text: S.of(context).cancel,
                  backgroundColor: theme.buttonTheme.colorScheme!.primary,
                  textStyle: theme.textTheme.button!.copyWith(
                      color: theme.buttonTheme.colorScheme!.secondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
