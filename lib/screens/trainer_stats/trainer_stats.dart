import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/widgets/months.dart';
import 'package:fox_fit/screens/trainer_stats/widgets/stats_card.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swipe/swipe.dart';

class TrainerStatsPage extends StatefulWidget {
  const TrainerStatsPage({Key? key}) : super(key: key);

  @override
  _TrainerStatsPageState createState() => _TrainerStatsPageState();
}

class _TrainerStatsPageState extends State<TrainerStatsPage> {
  late GeneralController controller;
  late int _currentMonth;
  late bool isLoading;
  late DateTime _now;

  @override
  void initState() {
    isLoading = true;
    controller = Get.find<GeneralController>();
    _now = DateTime.now();
    _now = DateTime(_now.year, _now.month, 1);
    _currentMonth = 2;

    getPerfomance(_currentMonth);

    super.initState();
  }

  void getPerfomance(int index) async {
    setState(() {
      isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: () {
        return controller.getTrainerPerfomance(
          perfomanceDate:
              controller.appState.value.trainerPerfomanceTimeStamp[index],
        );
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Swipe(
      onSwipeRight: () {
        if (!isLoading) {
          Get.back();
        }
      },
      child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: CustomAppBar(
            onNotification: () {
              Get.toNamed(Routes.notifications);
            },
            title: S.of(context).trainer_stats,
            isBackArrow: true,
            onBack: () async {
              if (!isLoading) {
                Get.back();

                await ErrorHandler.request(
                  context: context,
                  request: controller.getCustomers,
                  skipCheck: true,
                  handler: (_) async {
                    CustomSnackbar.getSnackbar(
                      title: S.of(context).error,
                      message: S.of(context).failed_update_list,
                    );
                  },
                );
              }
            },
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Column(
                  children: [
                    Months(
                      width: width,
                      months: controller.appState.value.trainerPerfomanceMonth,
                      currentIndex: _currentMonth,
                      onChange: (index) {
                        setState(() {
                          _currentMonth = index;
                        });
                        getPerfomance(_currentMonth);
                      },
                    ),
                    const SizedBox(height: 24),
                    !isLoading
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: controller
                                            .appState.value.trainerPerfomance !=
                                        null
                                    ? StatsCard(
                                        sales: controller.appState.value
                                            .trainerPerfomance!.amount,
                                        plan: controller.appState.value
                                            .trainerPerfomance!.plan,
                                        progress: controller.appState.value
                                            .trainerPerfomance!.done,
                                        duration: 350,
                                      )
                                    : const SizedBox(
                                        child: Text(
                                            'Не удалось загрузить статистику'),
                                      ),
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller
                                            .appState.value.trainerPerfomance !=
                                        null)
                                      _buildFunnel(
                                        theme,
                                        width: width * 0.75,
                                        image: Images.funnelNew,
                                        name: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[0]
                                            .name,
                                        count: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[0]
                                            .quantity,
                                        conversion: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[0]
                                            .conversion,
                                        lineWidth: width * 0.15,
                                      ),
                                    const SizedBox(height: 9),
                                    if (controller
                                            .appState.value.trainerPerfomance !=
                                        null)
                                      _buildFunnel(
                                        theme,
                                        width: width * 0.55,
                                        image: Images.funnelAssigned,
                                        name: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[1]
                                            .name,
                                        count: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[1]
                                            .quantity,
                                        conversion: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[1]
                                            .conversion,
                                        lineColor: theme.cardColor,
                                        lineWidth: width * 0.247,
                                        lineTopPadding: 7.2,
                                        isLineExtends: true,
                                      ),
                                    const SizedBox(height: 7.5),
                                    if (controller
                                            .appState.value.trainerPerfomance !=
                                        null)
                                      _buildFunnel(
                                        theme,
                                        isLightText: true,
                                        width: width * 0.4,
                                        image: Images.funnelPerfomed,
                                        name: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[2]
                                            .name,
                                        count: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[2]
                                            .quantity,
                                        conversion: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[2]
                                            .conversion,
                                        lineColor: theme.highlightColor,
                                        lineWidth: width * 0.32,
                                        lineTopPadding: 5,
                                        isLineExtends: true,
                                      ),
                                    const SizedBox(height: 7.5),
                                    if (controller
                                            .appState.value.trainerPerfomance !=
                                        null)
                                      _buildFunnel(
                                        theme,
                                        isLightText: true,
                                        width: width * 0.29375,
                                        image: Images.funnelStable,
                                        name: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[3]
                                            .name,
                                        count: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[3]
                                            .quantity,
                                        conversion: controller
                                            .appState
                                            .value
                                            .trainerPerfomance!
                                            .perfomanceStages[3]
                                            .conversion,
                                        lineColor: theme.disabledColor,
                                        lineWidth: width * 0.369,
                                        lineTopPadding: 4.5,
                                        isLineExtends: true,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 48.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ],
                )),
          )),
    );
  }

  Widget _buildFunnel(
    ThemeData theme, {
    required double width,
    required String image,
    required String name,
    required String count,
    double? lineWidth,
    required String conversion,
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
                '$conversion%',
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
