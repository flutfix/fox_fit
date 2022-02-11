import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/more_card.dart';
import 'package:fox_fit/utils/enums.dart';
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
          /// Статистика тренера
          MoreCardModel(
            text: S.of(context).trainer_stats,
            icon: Images.trainerStats,
            onTap: () {
              Get.toNamed(Routes.trainerStats);
            },
          ),

          /// Поддержка
          MoreCardModel(
            text: S.of(context).support,
            icon: Images.support,
            onTap: () async {
              await canLaunch(AppConfig.supportUrl)
                  ? launch(AppConfig.supportUrl)
                  : CustomSnackbar.getSnackbar(
                      title: S.of(context).whatsapp_exeption,
                      message: S.of(context).whatsapp_exeption_description,
                    );
            },
          ),

          /// Координатор
          if (_controller.appState.value.isCoordinator)
            MoreCardModel(
              text: S.of(context).coordinator,
              icon: Images.coordinatorPng,
              onTap: () {
                Get.toNamed(Routes.coordinator);
              },
            ),

          /// Смена пароля
          MoreCardModel(
            text: S.of(context).change_password,
            icon: Images.passPng,
            onTap: () {
              Get.toNamed(Routes.changePassword);
            },
          ),

          /// Выйти из профиля
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
          children: List.generate(
            cards.length,
            (index) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: (index != cards.length - 1) ? 5.0 : 0.0),
                child: _buildCard(
                  theme: theme,
                  text: cards[index].text,
                  icon: cards[index].icon,
                  onTap: cards[index].onTap,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required String text,
    required String icon,
    Function()? onTap,
  }) {
    return DefaultContainer(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 18,
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
          clientType: ClientType.coordinator,
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
