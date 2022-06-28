// ignore_for_file: unused_field

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/main.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/screens/customers/customers.dart';
import 'package:fox_fit/screens/more/more.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/bottom_bar.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/keep_alive_page.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);

  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> with WidgetsBindingObserver {
  late GeneralController _generalController;
  late ScheduleController _scheduleController;
  late PageController pageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late DateTime _now;
  String? _fcmToken = "";

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _generalController = Get.put(GeneralController());
    _scheduleController = Get.put(ScheduleController());
    pageController = PageController(initialPage: 0);
    AuthDataModel authData = Get.arguments;
    _generalController.appState.update((model) {
      model?.auth = authData;
    });

    /// Для статистики тренера
    _now = DateTime.now().toUtc();
    _now = DateTime(_now.year, _now.month, 3).toUtc();
    _generalController.appState.update((model) {
      model?.trainerPerfomanceMonth = [
        DateFormat.MMMM().format(
          DateTime(_now.year, _now.month - 2, 3),
        ),
        DateFormat.MMMM().format(DateTime(_now.year, _now.month - 1, 3)),
        DateFormat.MMMM().format(DateTime(_now.year, _now.month, 3))
      ];
      model?.trainerPerfomanceTimeStamp = [
        (DateTime(_now.year, _now.month - 2, _now.day).millisecondsSinceEpoch /
                1000)
            .round(),
        (DateTime(_now.year, _now.month - 1, _now.day).millisecondsSinceEpoch /
                1000)
            .round(),
        (_now.millisecondsSinceEpoch / 1000).round(),
      ];
    });

    if (authData.users!.length > 1) {
      _generalController.appState.update((model) {
        model?.isCoordinator = true;
      });
      _generalController.initVibration();
    }
    log('[Uid] ${_generalController.appState.value.auth?.users?[0].uid}');

    if (!isHMS) {
      /// Если приложение закрыто и пользователь нажимает на уведомление - его перекидывает на страницу [Уведомления]
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          Get.toNamed(Routes.notifications);
        }
      });
    }

    _load();

    super.initState();
  }

  /// Отслеживание когда приложение возвращается из фонового состояния и обновление данных, если [true]
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      return;
    }
    final isResumed = state == AppLifecycleState.resumed;

    if (isResumed) {
      log('[State] Was resumed from background');
      if (_generalController.appState.value.currentIndex != 4) {
        // Решение бага с обновлением первой страницы
        pageController = PageController(
          initialPage: _generalController.appState.value.currentIndex,
        );

        await _load();
      }
    }
  }

  /// Функция подгрузки данных, необходимых для инициализации приложения
  Future<void> _load() async {
    _generalController.appState.update((model) {
      model?.isLoading = true;
    });

    var prefs = await SharedPreferences.getInstance();
    if (!isHMS) {
      await _fcm();
    }
    await ErrorHandler.request(
      context: context,
      request: () {
        return _generalController.getCustomers(fcmToken: _fcmToken);
      },
      handler: (data) async {
        if (data == 401) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).license_error_title,
            message: S.of(context).license_error_body,
          );
          Get.delete<GeneralController>();
          prefs.setBool(Cache.isAuthorized, false);
          prefs.setString(Cache.pass, '');

          return false;
        } else if (data == 406 || data == null) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).server_error,
            message: S.of(context).server_navailable,
          );
          Get.delete<GeneralController>();
          prefs.setBool(Cache.isAuthorized, false);
          prefs.setString(Cache.pass, '');
          return false;
        }
      },
    );

    if (prefs.getBool(Cache.isAuthorized) == false) {
      await Get.offAllNamed(Routes.auth);
    }

    _generalController.appState.update((model) {
      model?.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Obx(
      () {
        if (!_generalController.appState.value.isLoading) {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: _appBar(
              theme,
              _generalController,
              onNotification: () async {
                var result = await Get.toNamed(Routes.notifications);
                if (result != null) {
                  if (result == 3) {
                    _generalController.appState.update((model) {
                      model?.isLoading = true;
                    });
                    await ErrorHandler.request(
                      context: context,
                      request: _generalController.getRegularCustomers,
                      repeat: false,
                      skipCheck: true,
                      handler: (_) async {
                        CustomSnackbar.getSnackbar(
                          title: S.of(context).error,
                          message: S.of(context).failed_update_list,
                        );
                      },
                    );
                    _generalController.appState.update((model) {
                      model?.isLoading = false;
                    });
                  }
                }
              },
            ),

            /// Страницы разделов Bottom Bar
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                ...List.generate(
                  _generalController.appState.value.bottomBarItems.length - 1,
                  (index) {
                    return const KeepAlivePage(child: CustomersPage());
                  },
                ),
                const MorePage(),
              ],
            ),
            bottomNavigationBar: Obx(
              () => CustomBottomBar(
                items: _generalController.appState.value.bottomBarItems,
                lineColor: theme.colorScheme.primary,
                activeColor: theme.colorScheme.primary,
                inActiveColor: theme.dividerColor.withOpacity(0.5),
                textColor: theme.hintColor,
                onChange: (index) {
                  setPage(index);
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 4,
              ),
            ),
          );
        }
      },
    );
  }

  CustomAppBar _appBar(ThemeData theme, GeneralController controller,
      {Function()? onNotification}) {
    var customers = controller.appState.value.sortedCustomers[controller
        .appState
        .value
        .bottomBarItems[controller.appState.value.currentIndex]
        .uid];
    return CustomAppBar(
      title: controller.appState.value
          .bottomBarItems[controller.appState.value.currentIndex].shortName,
      count: (customers != null) ? customers.length : null,
      onNotification: onNotification,
    );
  }

  void setPage(int index) {
    setState(() {
      Get.find<GeneralController>().appState.update((model) {
        model?.currentIndex = index;
      });
      pageController.jumpToPage(
        index,
      );
    });
  }

  ///---- Firebase Notifications
  Future<void> _fcm() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _fcmToken = '';

    /// Получение [FCM] токена устройства
    await FirebaseMessaging.instance.getToken().then((token) {
      log('[FCM Token] $token');
      _fcmToken = token;
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(AppConfig.pushChannel);

    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android:
              AndroidInitializationSettings('@drawable/res_notification_logo'),
          iOS: IOSInitializationSettings(),
        ), onSelectNotification: (payload) {
      Get.toNamed(Routes.notifications);
    });

    ///Стрим на прослушку оповещений
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            iOS: const IOSNotificationDetails(),
            android: AndroidNotificationDetails(
              AppConfig.pushChannel.id,
              AppConfig.pushChannel.name,
              channelDescription: AppConfig.pushChannel.description,
              icon: '@drawable/res_notification_logo',
              color: Colors.orange,
            ),
          ),
        );
      }
    });

    /// Когда приложение в фоновом состоянии и юзер нажал на уведомление
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.toNamed(Routes.notifications);
    });
    //----
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
