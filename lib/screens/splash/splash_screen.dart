import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fox_fit/api/auth.dart';
import 'package:fox_fit/api/general.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/utils/check_version.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/prefs.dart';
import 'package:get/get.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    ErrorHandler.request(
      context: context,
      request: _load,
    );
    super.initState();
  }

  Future<dynamic> _load() async {
    var isAuthorized = await Prefs.getPrefs(
      key: Cache.isAuthorized,
      prefsType: PrefsType.boolean,
    );
    if (isAuthorized != null) {
      if (isAuthorized) {
        var phone = await Prefs.getPrefs(
          key: Cache.phone,
          prefsType: PrefsType.string,
        );
        var pass = await Prefs.getPrefs(
          key: Cache.pass,
          prefsType: PrefsType.string,
        );
        var authData = await AuthRequest.auth(
          phone: phone,
          pass: pass,
        );
        if (authData is AuthDataModel) {
          bool actualVersion =
              await CheckVersion.checkingApplicationVersion(authData: authData);

          if (actualVersion) {
            await Future.delayed(const Duration(milliseconds: 400));
            final String pathToBase = await Prefs.getPrefs(
              key: Cache.pathToBase,
              prefsType: PrefsType.string,
            );
            final String baseAuth = await Prefs.getPrefs(
              key: Cache.baseAuth,
              prefsType: PrefsType.string,
            );

            /// Для идентификации API запросов
            Requests.url = pathToBase;
            Requests.options = BaseOptions(
              baseUrl: pathToBase,
              contentType: Headers.jsonContentType,
              headers: {
                HttpHeaders.authorizationHeader: 'Basic $baseAuth',
              },
              connectTimeout: 10000,
              receiveTimeout: 10000,
            );

            ///--

            Get.offNamed(
              Routes.general,
              arguments: authData,
            );
          } else {
            await Get.offAllNamed(Routes.update);
          }

          return 200;
        } else {
          log('[Splash screen] Auth Failed');
          return authData;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 400));
        Get.offNamed(Routes.auth);
        return 200;
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 400));
      Get.offNamed(Routes.auth);
      return 200;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.splashLogo,
                width: 220,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 4),
              Image.asset(
                Images.splashText,
                width: 220,
                fit: BoxFit.fill,
              )
            ],
          ),
        ),
      ),
    );
  }
}
