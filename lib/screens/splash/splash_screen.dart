import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/prefs.dart';
import 'package:get/get.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  late bool _isCalled;

  @override
  void initState() {
    _isCalled = false;

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
        var authData = await Requests.auth(
          phone: phone,
          pass: pass,
        );
        if (authData is int || authData == null) {
          return authData;
        } else {
          await Future.delayed(const Duration(milliseconds: 400));

          Get.offNamed(
            Routes.general,
            arguments: authData,
          );

          return 200;
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
    if (!_isCalled) {
      ErrorHandler.request(context: context, request: _load);
    }
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
