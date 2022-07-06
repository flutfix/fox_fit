import 'package:flutter/material.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/mocks/mocks.dart';
import 'package:fox_fit/screens/trainer_stats/widgets/history_container.dart';
import 'package:fox_fit/screens/trainer_stats/widgets/selector.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/months.dart';
import 'package:fox_fit/screens/trainer_stats/widgets/stats_card.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class TrainerStatsPage extends StatefulWidget {
  const TrainerStatsPage({Key? key}) : super(key: key);

  @override
  _TrainerStatsPageState createState() => _TrainerStatsPageState();
}

class _TrainerStatsPageState extends State<TrainerStatsPage> {
  late GeneralController _generalController;
  late int _infoController;
  late int _currentMonth;
  late bool isLoading;
  late DateTime _now;

  @override
  void initState() {
    isLoading = true;
    _generalController = Get.find<GeneralController>();
    _infoController = 0;
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
        return _generalController.getTrainerPerfomance(
          perfomanceDate: _generalController
              .appState.value.trainerPerfomanceTimeStamp[index],
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
                request: _generalController.getCustomers,
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
                  months:
                      _generalController.appState.value.trainerPerfomanceMonth,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: _generalController
                                        .appState.value.trainerPerfomance !=
                                    null
                                ? StatsCard(
                                    sales: _generalController.appState.value
                                        .trainerPerfomance!.amount,
                                    plan: _generalController
                                        .appState.value.trainerPerfomance!.plan,
                                    progress: _generalController
                                        .appState.value.trainerPerfomance!.done,
                                    duration: 350,
                                  )
                                : const SizedBox(
                                    child:
                                        Text('Не удалось загрузить статистику'),
                                  ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_generalController
                                        .appState.value.trainerPerfomance !=
                                    null)
                                  _buildFunnel(
                                    theme,
                                    width: width * 0.75,
                                    image: Images.funnelNew,
                                    name: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[0]
                                        .name,
                                    count: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[0]
                                        .quantity,
                                    conversion: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[0]
                                        .conversion,
                                    lineWidth: width * 0.15,
                                  ),
                                const SizedBox(height: 9),
                                if (_generalController
                                        .appState.value.trainerPerfomance !=
                                    null)
                                  _buildFunnel(
                                    theme,
                                    width: width * 0.55,
                                    image: Images.funnelAssigned,
                                    name: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[1]
                                        .name,
                                    count: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[1]
                                        .quantity,
                                    conversion: _generalController
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
                                if (_generalController
                                        .appState.value.trainerPerfomance !=
                                    null)
                                  _buildFunnel(
                                    theme,
                                    isLightText: true,
                                    width: width * 0.4,
                                    image: Images.funnelPerfomed,
                                    name: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[2]
                                        .name,
                                    count: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[2]
                                        .quantity,
                                    conversion: _generalController
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
                                if (_generalController
                                        .appState.value.trainerPerfomance !=
                                    null)
                                  _buildFunnel(
                                    theme,
                                    isLightText: true,
                                    width: width * 0.29375,
                                    image: Images.funnelStable,
                                    name: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[3]
                                        .name,
                                    count: _generalController
                                        .appState
                                        .value
                                        .trainerPerfomance!
                                        .perfomanceStages[3]
                                        .quantity,
                                    conversion: _generalController
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
                const SizedBox(height: 32),

                // Кнопки выбора подробной информации
                Selector(
                  controller: _infoController,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (int index) {
                    setState(() {
                      _infoController = index;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Подробная информация
                _infoStats(theme: theme),
              ],
            ),
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

  Widget _infoStats({
    required ThemeData theme,
  }) {
    // История
    if (_infoController == 0) {
      return ListView.separated(
        itemCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 6,
          );
        },
        itemBuilder: (context, index) {
          return HistoryContainer(
            historyStats: Mocks.historyStats,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          );
        },
      );

      // Услуги
    } else if (_infoController == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 29),
              child: Text(
                '${S.of(context).total} ${Mocks.serviceStats.amount} ${S.of(context).pcs}.',
                style: theme.textTheme.headline3!.copyWith(
                  color: Styles.blue,
                ),
              ),
            ),
            const SizedBox(height: 14),
            DefaultContainer(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 27),
              child: ListView.separated(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 21,
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        color: theme.dividerColor.withOpacity(0.2),
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                    ],
                  );
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${Mocks.serviceStats.count} ${S.of(context).pcs}',
                          style: theme.textTheme.headline4!.copyWith(
                            color: Styles.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        Mocks.serviceStats.name,
                        style: theme.textTheme.bodyText1,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

      // Клиенты
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 29),
              child: Text(
                '${S.of(context).total} ${Mocks.serviceStats.amount} ${S.of(context).pcs}.',
                style: theme.textTheme.headline3!.copyWith(
                  color: Styles.blue,
                ),
              ),
            ),
            const SizedBox(height: 14),
            ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 6,
                );
              },
              itemBuilder: (context, index) {
                return DefaultContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${Mocks.clientStats.count} ${S.of(context).pcs}',
                          style: theme.textTheme.headline4!.copyWith(
                            color: Styles.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        Mocks.clientStats.name,
                        style: theme.textTheme.bodyText1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
