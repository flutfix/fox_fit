import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDlDrc6NbcGVR4rr8DTfV82dAk_vD3Jpi0",
      appId: "1:150088765423:ios:23edb87f9ecb47a756301a",
      messagingSenderId: "150088765423",
      projectId: "android-foxfit-push",
    ));
  } else {
    await Firebase.initializeApp();
  }
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
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDlDrc6NbcGVR4rr8DTfV82dAk_vD3Jpi0",
      appId: "1:150088765423:ios:23edb87f9ecb47a756301a",
      messagingSenderId: "150088765423",
      projectId: "android-foxfit-push",
    ));
  } else {
    await Firebase.initializeApp();
  }
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
        getPages: Routes.getRoutes,
      ),
    );
  }
}
