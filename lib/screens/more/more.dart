import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/more_card.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late List<MoreCardModel> cards;
  @override
  void initState() {
    cards = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () {},
          ),
        ];
      });
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: List.generate(cards.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: (index != cards.length - 1) ? 5.0 : 0.0),
              child: _buildCard(
                text: cards[index].text,
                icon: cards[index].icon,
                onTap: cards[index].onTap,
              ),
            );
          }),
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
}
