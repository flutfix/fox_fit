import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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
import 'package:fox_fit/widgets/snackbar.dart';
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
  late final GeneralController _controller;
  late final ScheduleController _scheduleController;
  late bool _canVibrate;
  late DateTime _dateNow;
  late final List<MonthModel> _months;
  late int _currentYear;
  late int _currentMonthIndex;
  late int _currentDayIndex;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _controller = Get.find<GeneralController>();
    _scheduleController = Get.find<ScheduleController>();

    _canVibrate = _controller.appState.value.isCanVibrate;

    /// Для открытия только что записанной,
    /// отредактированной или удалённой тренировки
    _dateNow = _scheduleController.state.value.date != null &&
            _scheduleController.state.value.time != null
        ? DateTime(
            _scheduleController.state.value.date!.year,
            _scheduleController.state.value.date!.month,
            _scheduleController.state.value.date!.day,
            _scheduleController.state.value.time!.hour,
          )
        : DateTime.now();

    _currentYear = _dateNow.year;

    _months = _getMonth(dateNow: _dateNow);

    MonthModel? currentMonth;
    currentMonth =
        _months.firstWhere((element) => element.number == _dateNow.month);

    _currentMonthIndex = _months.indexOf(currentMonth);
    _currentDayIndex = _dateNow.day - 1;

    getAppointments();
  }

  void getAppointments() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: () {
        return _scheduleController.getAppointments(
          userUid: _controller.getUid(role: UserRole.trainer),
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

    /// [(width - 50) / 3)] - ширина контейнера, [5] - отступы между контейнерами
    ScrollController _scrollControllerMonth = ScrollController(
      initialScrollOffset: ((width - 50) / 3 + 5) * (_currentMonthIndex - 1),
    );

    /// [(width - 96) / 5] - ширина контейнера, [8] - отступы между контейнерами
    ScrollController _scrollControllerDays = ScrollController(
      initialScrollOffset: ((width - 96) / 5 + 8) * (_currentDayIndex - 2),
    );

    /// [89] - высота контейнера, [7] - отступы между контейнерами
    ScrollController _scrollControllerLessons = ScrollController(
      initialScrollOffset: ((89 + 7) * _dateNow.hour) + 13,
    );

    return Swipe(
      onSwipeRight: () async {
        _scheduleController.clear(appointment: true);
        await ErrorHandler.request(
          context: context,
          request: _controller.getCustomers,
          repeat: false,
          skipCheck: true,
          handler: (_) async {
            CustomSnackbar.getSnackbar(
              title: S.of(context).error,
              message: S.of(context).failed_update_list,
            );
          },
        );
        Get.back();
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(
          title: S.of(context).schedule,
          isBackArrow: true,
          isNotification: false,
          onBack: () async {
            _scheduleController.clear(appointment: true);
            await ErrorHandler.request(
              context: context,
              request: _controller.getCustomers,
              repeat: false,
              skipCheck: true,
              handler: (_) async {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).error,
                  message: S.of(context).failed_update_list,
                );
              },
            );
            Get.back();
          },
          action: GestureDetector(
            onTap: () {
              if (_canVibrate) {
                Vibrate.feedback(FeedbackType.light);
              }
              getAppointments();
            },
            behavior: HitTestBehavior.translucent,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                SvgPicture.asset(
                  Images.refresh,
                  width: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 36)
              ],
            ),
          ),
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
              attenuation: true,
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
                if (index != 0 &&
                    index != 1 &&
                    index != lastIndex &&
                    index != lastIndex - 1) {
                  _animateDays(
                    scrollControllerDays: _scrollControllerDays,
                    width: width,
                    index: index,
                  );
                  _updateDay(index: index);
                } else {
                  _updateDay(index: index);
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
                                child: Lessons(date: _dateNow),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 130,
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
              _scheduleController.clear(appointment: true);
              _scheduleController.state.update((model) {
                model?.appointmentRecordType = AppointmentRecordType.create;
              });
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
      /// Переход к текущему дню, есил выбран текущий месяц
      if (index == 3) {
        _currentMonthIndex = index;
        _animateDays(
          scrollControllerDays: scrollControllerDays,
          width: width,
          index: DateTime.now().day - 1,
        );
        _updateDay(index: DateTime.now().day - 1);

        /// Выбран месяц по навравлению влево от текущего
      } else if (index - _currentMonthIndex < 0) {
        _currentMonthIndex = index;
        _animateDays(
          scrollControllerDays: scrollControllerDays,
          width: width,
          index: _months[_currentMonthIndex].days.length - 1,
        );
        _updateDay(index: _months[_currentMonthIndex].days.length - 1);

        /// Выбран месяц по навравлению вправо от текущего
      } else if (index - _currentMonthIndex > 0) {
        _currentMonthIndex = index;
        _animateDays(
          scrollControllerDays: scrollControllerDays,
          width: width,
          index: 0,
        );
        _updateDay(index: 0);
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
  }

  _updateDay({required int index}) {
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
