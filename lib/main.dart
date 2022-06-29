import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:huawei_push/huawei_push.dart' as hms;
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Platform.isIOS) {
    await Firebase.initializeApp(options: AppConfig.firebaseOptions);
  } else {
    await Firebase.initializeApp();
  }
  log("[Firebase] Handling a background message: ${message.messageId}");
}

bool isHMS = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  isHMS = const String.fromEnvironment("flavor") == 'hms';

  if (!isHMS) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _init();
  } else {
    await _initHms();
    // _getTokenHms();
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

Future _init() async {
  if (Platform.isIOS) {
    await Firebase.initializeApp(options: AppConfig.firebaseOptions);
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

Future<void> _initHms() async {
  // if (!mounted) return;
  hms.Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
}

void _onTokenEvent(String event) {
  // This function gets called when we receive the token successfully
  String _token = event;
  log('Push Token: ' + _token);
  hms.Push.showToast(event.toString());
}

void _onTokenError(Object error) {
  PlatformException e = error as PlatformException;
  log("TokenErrorEvent: ${e.message}");
}

// void _getTokenHms() {
//   hms.Push.getToken('');
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool gms;
  late bool hms;

  @override
  void initState() {
    super.initState();
    gms = false;
    hms = false;

    // Проверка доступа GMS & HMS сервисов
    FlutterHmsGmsAvailability.isGmsAvailable.then((t) {
      setState(() {
        gms = t;
      });
    });
    FlutterHmsGmsAvailability.isHmsAvailable.then((t) {
      setState(() {
        hms = t;
      });
    });

    log('---[Services availability]----\n');
    log('GMS availability = $gms');
    log('HMS availability = $hms\n');
    log('------------------------------');
  }

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
        locale: const Locale('ru', 'RU'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        initialRoute: Routes.splash,
        getPages: Routes.getRoutes,
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
      ),
    );
  }
}
