import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/screens/customers/customers.dart';
import 'package:fox_fit/screens/more/more.dart';
import 'package:fox_fit/utils/snackbar.dart';
import 'package:fox_fit/widgets/bottom_bar.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/keep_alive_page.dart';
import 'package:get/get.dart';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);

  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  late GeneralController controller;
  late PageController pageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late String? _fcmToken;

  @override
  void initState() {
    controller = Get.put(GeneralController());

    AuthDataModel authData = Get.arguments;
    controller.appState.update((model) {
      model?.auth = authData;
    });
    if (authData.users!.length > 1) {
      controller.appState.update((model) {
        model?.isCoordinator = true;
      });

      _load();
      controller.initVibration();
    }
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  Future<void> _load() async {
    controller.appState.update((model) {
      model?.isLoading = true;
    });
    await _fcm();
    await controller.getCustomers(fcmToken: _fcmToken);
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
                activeColor: theme.hintColor,
                inActiveColor: theme.hoverColor,
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
        onNotification: () {});
  }

  void setPage(int index) {
    Get.find<GeneralController>().appState.update((model) {
      model?.currentIndex = index;
    });
    pageController.jumpToPage(
      index,
    );
  }

  ///---- Firebase Notifications liste
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
    //----
  }
}
