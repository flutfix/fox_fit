import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/month.dart';
import 'package:fox_fit/screens/more/pages/schedule/widgets/lessons.dart';
import 'package:fox_fit/screens/more/pages/schedule/widgets/time_feed.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/widgets/days.dart';
import 'package:fox_fit/widgets/months.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swipe/swipe.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late bool _isLoading;
  late final GeneralController _generalController;
  late final ScheduleController _scheduleController;
  late DateTime _dateNow;
  late final List<MonthModel> _months;
  late int _currentYear;
  late int _currentMonthIndex;
  late int _currentDayIndex;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _generalController = Get.find<GeneralController>();
    _scheduleController = Get.put(ScheduleController());

    _scheduleController.scheduleState.update((model) {
      model?.uid = _generalController.appState.value.auth!.users![0].uid;
    });

    _dateNow = DateTime.now();

    _currentYear = _dateNow.year;

    _months = _getMonth(dateNow: _dateNow);

    _currentMonthIndex = (_months.length / 2).floor();
    _currentDayIndex = _dateNow.day - 1;

    getAppointments();
  }

  void getAppointments() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.loadingData(
      context: context,
      request: () {
        return _scheduleController.getAppointments(
          userUid: _scheduleController.scheduleState.value.uid!,
          dateNow: _dateNow,
        );
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    /// [(width - 50) / 3)] - длина контейнера, [5] - отступы между контейнерами
    ScrollController _scrollControllerMonth = ScrollController(
      initialScrollOffset: ((width - 50) / 3 + 5) * (_currentMonthIndex - 1),
    );

    /// [(width - 96) / 5] - длина контейнера, [8] - отступы между контейнерами
    ScrollController _scrollControllerDays = ScrollController(
      initialScrollOffset: ((width - 96) / 5 + 8) * (_currentDayIndex - 2),
    );

    /// [(width - 50) / 3)] - длина контейнера, [8] - отступы между контейнерами
    ScrollController _scrollControllerLessons = ScrollController(
      initialScrollOffset: ((89 + 7) * _dateNow.hour) + 13,
    );

    return Swipe(
      onSwipeRight: () => Get.back(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(
          title: S.of(context).schedule,
          isBackArrow: true,
          isNotification: false,
          onBack: () {
            Get.delete<ScheduleController>();
            Get.back();
          },
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),

            /// Слайдер месяцев
            Months(
              controller: _scrollControllerMonth,
              months: [
                for (int i = 0; i < _months.length; i++) _months[i].month
              ],
              currentIndex: _currentMonthIndex,
              width: width,
              onChange: (index) {
                int lastIndex = _months.length - 1;

                if ((index - _currentMonthIndex).abs() == 1) {
                  _animateMonths(
                    scrollControllerMonth: _scrollControllerMonth,
                    scrollControllerDays: _scrollControllerDays,
                    width: width,
                    index: index,
                  );
                } else if (_currentMonthIndex == 0 ||
                    _currentMonthIndex == lastIndex) {
                  _animateMonths(
                    scrollControllerMonth: _scrollControllerMonth,
                    scrollControllerDays: _scrollControllerDays,
                    width: width,
                    index: index,
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            /// Слайдер дней
            Days(
              days: _months[_currentMonthIndex].days,
              currentIndex: _currentDayIndex,
              width: width,
              controller: _scrollControllerDays,
              onChange: (index) {
                int lastIndex = _months[_currentMonthIndex].days.length - 1;

                if (((index - _currentDayIndex).abs() <= 2)) {
                  _animateDays(
                    scrollControllerDays: _scrollControllerDays,
                    width: width,
                    index: index,
                  );
                } else if (_currentDayIndex == 0 ||
                    _currentDayIndex == 1 ||
                    _currentDayIndex == lastIndex ||
                    _currentDayIndex == lastIndex - 1) {
                  _animateDays(
                    scrollControllerDays: _scrollControllerDays,
                    width: width,
                    index: index,
                  );
                }
              },
            ),
            const SizedBox(height: 12),

            /// Лента времени
            !_isLoading
                ? Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollControllerLessons,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(33, 12, 20, 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TimeFeed(),
                              const SizedBox(width: 17),
                              Padding(
                                padding: const EdgeInsets.only(top: 13.0),
                                child: Lessons(),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  theme.backgroundColor.withOpacity(0),
                                  theme.backgroundColor.withOpacity(0.9),
                                  theme.backgroundColor,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 150),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: CustomTextButton(
            onTap: () {
              Get.toNamed(Routes.signUpTrainingSession);
            },
            height: 51,
            text: S.of(context).record,
            backgroundColor: theme.colorScheme.secondary,
            textStyle: theme.textTheme.button!,
          ),
        ),
      ),
    );
  }

  /// Получение месяцов за период от трёх месяцев назад от текущего
  /// до трёх месяцев вперёд от текущего
  List<MonthModel> _getMonth({required DateTime dateNow}) {
    List<MonthModel> months = [];
    int numberMonth = 0;
    for (int i = dateNow.month - 3; i <= dateNow.month + 3; i++) {
      int year = _currentYear;
      if (i < 1) {
        numberMonth = i + 12;
        year--;
      } else if (i > 12) {
        numberMonth = i - 12;
        year++;
      } else {
        numberMonth = i;
      }
      setState(() {});
      months.add(
        MonthModel(
          year: year,
          month: DateFormat('MMMM').format(DateTime(year, i)),
          number: numberMonth,
          days: _getDays(year: year, month: i),
        ),
      );
    }

    return months;
  }

  /// Получение всех дней месяца
  List<DaysModel> _getDays({
    required int year,
    required int month,
  }) {
    List<DaysModel> days = [];
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(
        DaysModel(
          day: DateFormat('EE').format(DateTime(year, month, i)),
          number: i,
        ),
      );
    }

    return days;
  }

  /// Анимирование перехода по месяцам
  void _animateMonths({
    required ScrollController scrollControllerMonth,
    required ScrollController scrollControllerDays,
    required double width,
    required int index,
  }) {
    scrollControllerMonth.animateTo(
      ((width - 50) / 3 + 5) * (index - 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    setState(() {
      if (index - _currentMonthIndex < 0) {
        _currentMonthIndex = index;
        _animateDays(
          scrollControllerDays: scrollControllerDays,
          width: width,
          index: _months[_currentMonthIndex].days.length - 1,
        );
      } else if (index - _currentMonthIndex > 0) {
        _currentMonthIndex = index;
        _animateDays(
          scrollControllerDays: scrollControllerDays,
          width: width,
          index: 0,
        );
      }
    });
  }

  /// Анимирование перехода по дням
  void _animateDays({
    required ScrollController scrollControllerDays,
    required double width,
    required int index,
  }) {
    scrollControllerDays.animateTo(
      ((width - 96) / 5 + 8) * (index - 2),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    setState(() {
      _currentDayIndex = index;
      _dateNow = DateTime(
        _months[_currentMonthIndex].year,
        _months[_currentMonthIndex].number,
        _months[_currentMonthIndex].days[_currentDayIndex].number,
        DateTime.now().hour,
      );
    });
    getAppointments();
  }
}
