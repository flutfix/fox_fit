part of push_service;

class PushService implements IService {
  @override
  Future<void> init() async {
    await Firebase.initializeApp();
    if (Platform.isIOS) {
      await Firebase.initializeApp(options: _firebaseOptions);
    } else {
      await Firebase.initializeApp();
    }
    FirebaseMessaging fcm = FirebaseMessaging.instance;

    ///Request permissions for Ios
    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  Future<void> listener<T>({T? plugin}) async {
    plugin as FlutterLocalNotificationsPlugin;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        plugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            iOS: IOSNotificationDetails(),
            android: AndroidNotificationDetails(
              'default_notification_channel',
              'Notifications',
              channelDescription: 'This channel is used for notifications.',
              icon: '@drawable/res_notification_logo',
              color: Colors.orange,
            ),
          ),
        );
      }
    });
  }

  @override
  Future<void> backgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage((message) async {
      if (Platform.isIOS) {
        await Firebase.initializeApp(options: _firebaseOptions);
      } else {
        await Firebase.initializeApp();
      }
      log("[Firebase] Handling a background message: ${message.messageId}");
    });
  }

  @override
  Future<void> onTapWhenAppFon({required Function() onTap}) async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onTap;
    });
  }

  @override
  Future<void> onTapWhenAppClosed({required Function() onTap}) async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        onTap;
      }
    });
  }
}

const FirebaseOptions _firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyDlDrc6NbcGVR4rr8DTfV82dAk_vD3Jpi0",
  appId: "1:150088765423:ios:23edb87f9ecb47a756301a",
  messagingSenderId: "150088765423",
  projectId: "android-foxfit-push",
);
