import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/screens/customers/customers.dart';
import 'package:fox_fit/screens/more/more.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/bottom_bar.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/keep_alive_page.dart';
import 'package:get/get.dart';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);

  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> with WidgetsBindingObserver {
  late GeneralController controller;
  late PageController pageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late String? _fcmToken;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    controller = Get.put(GeneralController());

    AuthDataModel authData = Get.arguments;
    controller.appState.update((model) {
      model?.auth = authData;
    });
    if (authData.users!.length > 1) {
      controller.appState.update((model) {
        model?.isCoordinator = true;
      });
      controller.initVibration();
    }

    /// Если приложение закрыто и пользователь нажимает на уведомление - его перекидывает на страницу [Уведомления]
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      log(message.toString());
      if (message != null) {
        Get.toNamed(Routes.notifications);
      }
    });

    _load();

    pageController = PageController(initialPage: 0);
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
      if (controller.appState.value.currentIndex != 4) {
        await _load();
      }
    }
  }

  /// Функция подгрузки данных, необходимых для инициализации приложения
  Future<void> _load() async {
    controller.appState.update((model) {
      model?.isLoading = true;
    });
    await _fcm();
    await ErrorHandler.loadingData(
      context: context,
      request: () {
        return controller.getCustomers(fcmToken: _fcmToken);
      },
    );

    controller.appState.update((model) {
      model?.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Obx(
      () {
        if (!controller.appState.value.isLoading) {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: appBar(theme, controller),

            /// Страницы разделов Bottom Bar
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                ...List.generate(
                  controller.appState.value.bottomBarItems.length - 1,
                  (index) {
                    return const KeepAlivePage(child: CustomersPage());
                  },
                ),
                const MorePage(),
              ],
            ),
            bottomNavigationBar: Obx(
              () => CustomBottomBar(
                items: controller.appState.value.bottomBarItems,
                lineColor: theme.colorScheme.primary,
                activeColor: theme.colorScheme.primary,
                inActiveColor: theme.dividerColor.withOpacity(0.5),
                textColor: theme.hintColor,
                onChange: (index) {
                  setState(() {
                    setPage(index);
                  });
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

  CustomAppBar appBar(ThemeData theme, GeneralController controller) {
    var customers = controller.appState.value.sortedCustomers[controller
        .appState
        .value
        .bottomBarItems[controller.appState.value.currentIndex]
        .uid];
    return CustomAppBar(
        title: controller.appState.value
            .bottomBarItems[controller.appState.value.currentIndex].shortName,
        count: (customers != null) ? customers.length : null,
        onNotification: () {
          Get.toNamed(Routes.notifications);
        });
  }

  void setPage(int index) {
    Get.find<GeneralController>().appState.update((model) {
      model?.currentIndex = index;
    });
    pageController.jumpToPage(
      index,
    );
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
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
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
