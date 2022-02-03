import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/stats.dart';
import 'package:fox_fit/screens/trainer_stats/widgets/moths.dart';
import 'package:fox_fit/screens/trainer_stats/widgets/stats_card.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';

class TrainerStatsPage extends StatefulWidget {
  const TrainerStatsPage({Key? key}) : super(key: key);

  @override
  _TrainerStatsPageState createState() => _TrainerStatsPageState();
}

class _TrainerStatsPageState extends State<TrainerStatsPage> {
  late List<MonthModel> months;
  late int currentIndex;
  @override
  void initState() {
    months = [
      MonthModel(
        text: 'декабрь',
      ),
      MonthModel(
        text: 'январь',
      ),
      MonthModel(
        text: 'февраль',
        isActive: true,
      )
    ];
    currentIndex = months.indexWhere((element) => element.isActive);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).trainer_stats,
        isBackArrow: true,
        onBack: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 25.0,
          ),
          child: Column(
            children: [
              Months(
                width: width,
                items: months,
                currentIndex: currentIndex,
                onChange: (index) {
                  int oldIndex =
                      months.indexWhere((element) => element.isActive);
                  if (index != oldIndex) {
                    setState(() {
                      months[oldIndex].isActive = false;
                      months[index].isActive = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              const StatsCard(
                sales: 16000,
                plan: 20000,
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFunnel(
                    theme,
                    width: width * 0.6,
                    image: Images.funnelNew,
                    name: 'новые',
                    lineWidth: width * 0.3,
                    count: '100',
                  ),
                  const SizedBox(height: 9),
                  _buildFunnel(
                    theme,
                    width: width * 0.44,
                    image: Images.funnelAssigned,
                    name: 'назначено',
                    count: '50',
                    lineColor: theme.cardColor,
                    lineWidth: width * 0.379,
                    lineTopPadding: 6,
                    isLineExtends: true,
                  ),
                  const SizedBox(height: 7.5),
                  _buildFunnel(
                    theme,
                    isLightText: true,
                    width: width * 0.32,
                    image: Images.funnelPerfomed,
                    name: 'проведено',
                    count: '30',
                    lineColor: theme.highlightColor,
                    lineWidth: width * 0.437,
                    lineTopPadding: 4,
                    isLineExtends: true,
                  ),
                  const SizedBox(height: 7.5),
                  _buildFunnel(
                    theme,
                    isLightText: true,
                    width: width * 0.235,
                    image: Images.funnelStable,
                    name: 'постоянных',
                    count: '20',
                    lineColor: theme.disabledColor,
                    lineWidth: width * 0.477,
                    lineTopPadding: 4,
                    isLineExtends: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFunnel(
    ThemeData theme, {
    required double width,
    required String image,
    required String name,
    required String count,
    required double lineWidth,
    double lineTopPadding = 0,
    Color lineColor = Colors.transparent,
    bool isLineExtends = false,
    bool isLightText = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: lineTopPadding),
              width: lineWidth,
              height: 1,
              color: lineColor,
            ),
            if (isLineExtends)
              Text(
                '5%',
                style: theme.textTheme.headline5,
              ),
            if (isLineExtends)
              Text(
                'конверсия',
                style: theme.textTheme.subtitle2,
              )
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              image,
              width: width,
              fit: BoxFit.fill,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count,
                  style: isLightText
                      ? theme.textTheme.subtitle1!
                          .copyWith(color: theme.colorScheme.surface)
                      : theme.textTheme.subtitle1,
                ),
                Text(
                  name,
                  style: isLightText
                      ? theme.textTheme.subtitle2!
                          .copyWith(color: theme.colorScheme.surface)
                      : theme.textTheme.subtitle2,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
