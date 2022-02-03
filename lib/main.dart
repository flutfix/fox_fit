import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/auth.dart';
import 'package:fox_fit/screens/customer_information/customer_information.dart';
import 'package:fox_fit/screens/general/general.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
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
        initialRoute: Routes.auth,
        getPages: [
          getPage(Routes.auth, () => const AuthPage()),
          getPage(Routes.general, () => const General()),
          getPage(Routes.customerInformation,
              () => const CustomerInformationPage()),
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
