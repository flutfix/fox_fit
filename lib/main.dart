import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fox_fit/screens/home/general.dart';
import 'package:fox_fit/screens/more/pages/change_password/change_password.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/schedule.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/sign_up_training_session.dart';
import 'package:fox_fit/screens/more/pages/sleeping_customers/sleeping_customers.dart';
import 'package:fox_fit/screens/notifications/notifications.dart';
import 'package:fox_fit/screens/splash/splash_screen.dart';
import 'package:fox_fit/screens/trainer_choosing/trainer_choosing.dart';
import 'package:fox_fit/screens/trainer_stats/trainer_stats.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'screens/more/pages/coordinator/coordinator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  log("[Firebase] Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

Future _init() async {
  await Firebase.initializeApp();
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  ///Request permissions for Ios
  await _fcm.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerTriggerDistance: 20,
      headerBuilder: () => CustomHeader(
        refreshStyle: RefreshStyle.UnFollow,
        builder: (context, status) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width - 16) / 2,
              30,
              (MediaQuery.of(context).size.width - 16) / 2,
              0,
            ),
            child: const SizedBox(
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
      child: GetMaterialApp(
        title: 'FoxFit',
        debugShowCheckedModeBanner: false,
        theme: Styles.getLightTheme,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('ru', 'RU'),
        supportedLocales: S.delegate.supportedLocales,
        initialRoute: Routes.splash,
        getPages: [
          getPage(Routes.splash, () => const SpalshScreen()),
          getPage(Routes.auth, () => const AuthPage()),
          getPage(Routes.general, () => const General()),
          getPage(Routes.trainerStats, () => const TrainerStatsPage()),
          getPage(Routes.trainerChoosing, () => const TrainerChoosingPage()),
          getPage(Routes.coordinator, () => const CoordinatorPage()),
          getPage(Routes.changePassword, () => const ChangePasswordPage()),
          getPage(Routes.coordinator, () => const CoordinatorPage()),
          getPage(Routes.notifications, () => const NotificationsPage()),
          getPage(
            Routes.sleepingCustomers,
            () => const SleepingCustomersPage(),
          ),
          getPage(Routes.schedule, () => const SchedulePage()),
          getPage(
            Routes.signUpTrainingSession,
            () => const SignUpTrainingSessionPage(),
          ),
        ],
      ),
    );
  }

  GetPage<dynamic> getPage(String routeName, Widget Function() page) {
    return GetPage(
      name: routeName,
      transition: Transition.fadeIn,
      curve: Curves.easeOut,
      page: page,
    );
  }
}
