import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/more_card.dart';
import 'package:fox_fit/widgets/bottom_sheet.dart';
import 'package:fox_fit/widgets/default_container.dart';
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
  late GeneralController controller;

  @override
  void initState() {
    cards = [];
    controller = Get.put(GeneralController());
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
                  : print(
                      "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
            },
          ),

          /// Координатор
          MoreCardModel(
            text: S.of(context).coordinator,
            icon: Images.coordinator,
            onTap: () {},
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
                    Get.delete<GeneralController>();
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setBool(Cashe.isAuthorized, false);
                    prefs.setString(Cashe.pass, '');

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
