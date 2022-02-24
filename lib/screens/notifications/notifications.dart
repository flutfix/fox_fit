import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/notification.dart';
import 'package:fox_fit/screens/customer_information/customer_information.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe/swipe.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late GeneralController _controller;
  late bool _isLoading;
  late String _currentDateTimestamp;
  late RefreshController _refreshController;
  late bool _canVibrate;

  @override
  void initState() {
    _isLoading = false;
    _currentDateTimestamp = '';
    _refreshController = RefreshController(initialRefresh: false);
    _controller = Get.find<GeneralController>();
    _load();
    _canVibrate = _controller.appState.value.isCanVibrate;
    super.initState();
  }

  _load() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: _controller.getNotifications,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: _onBack,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: _appBar(),
        body: !_isLoading
            ? _controller.appState.value.notifications.isNotEmpty
                ? SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _refresh,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                        child: Obx(
                          (() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    _controller.appState.value.notifications
                                        .length, (index) {
                                  var notification = _controller
                                      .appState.value.notifications[index];

                                  /// Блок если день сменился
                                  if (_currentDateTimestamp !=
                                      notification.date) {
                                    _currentDateTimestamp = notification.date;

                                    dynamic date = _timeStampToFormattedDate(
                                        timestamp: _currentDateTimestamp);

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 25),
                                        Text(
                                          date,
                                          style: theme.textTheme.bodyText2!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 16),
                                        _getNotificationContainer(
                                          theme,
                                          notification,
                                          onTap: () =>
                                              onNotificationTap(notification),
                                        ),
                                      ],
                                    );

                                    /// Просто уведомление если день все тот же
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: _getNotificationContainer(
                                        theme,
                                        notification,
                                        onTap: () =>
                                            onNotificationTap(notification),
                                      ),
                                    );
                                  }
                                }),
                              )),
                        ),
                      ),
                    ),
                  )
                : const Center(child: Text('Уведомлений нет'))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  onNotificationTap(NotificationModel notification) {
    if (notification.isVisible) {
      if (notification.phone != '' && notification.pipelineUid != '') {
        Get.to(
          () => CustomerInformationPage(
            clientType:
                Enums.getClientType(clientUid: notification.pipelineUid),
            isFromNotification: true,
          ),
          arguments: notification.phone,
          transition: Transition.fadeIn,
        );
      }
    }
  }

  Widget _getNotificationContainer(
    ThemeData theme,
    NotificationModel notification, {
    required Function() onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: DefaultContainer(
          isHighlight: notification.isNew,
          highlightColor: Styles.green.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Текст уведомления
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      notification.text,
                      style: theme.textTheme.bodyText2,
                    ),
                  ),

                  const SizedBox(height: 4),
                ],
              ),

              /// Время
              Text(
                notification.time,
                style: theme.textTheme.overline,
              ),
            ],
          )),
    );
  }

  CustomAppBar _appBar() {
    return CustomAppBar(
      title: S.of(context).notifications,
      isBackArrow: true,
      onBack: _onBack,
      onNotification: () {},
    );
  }

  _timeStampToFormattedDate({required String timestamp}) {
    var _date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000)
        .toUtc();
    return DateFormat('d MMMM', 'ru').format(_date);
  }

  Future<void> _setPrefs({required String timestamp}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Cache.lastCheckNotifications, timestamp);
  }

  _onBack() async {
    await _setPrefs(timestamp: _getRelevanceDate);
    Get.back();
    _updateNotificationIconColor();
    await ErrorHandler.request(
      context: context,
      request: _controller.getCustomers,
      repeat: false,
      skipCheck: true,
      handler: (_) async {
        CustomSnackbar.getSnackbar(
          title: S.of(context).no_internet_access,
          message: S.of(context).failed_update_list,
        );
      },
    );
  }

  Future<void> _refresh() async {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }

    await _setPrefs(timestamp: _getRelevanceDate);
    await ErrorHandler.request(
      context: context,
      request: _controller.getNotifications,
      repeat: false,
    );

    _updateNotificationIconColor();
    _refreshController.refreshCompleted();
  }

  String get _getRelevanceDate {
    dynamic _relevanceDate = DateTime.now().toUtc();
    return _relevanceDate =
        (_relevanceDate.millisecondsSinceEpoch / 1000).round().toString();
  }

  void _updateNotificationIconColor() {
    _controller.appState.update((model) {
      model?.isNewNotifications = false;
    });
  }
}
