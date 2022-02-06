import 'package:flutter/material.dart';
import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/config/routes.dart';
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

  Future<void> _load() async {
    var isAuthorized = await Requests.getPrefs(
      key: Cache.isAuthorized,
      prefsType: PrefsType.boolean,
    );
    if (isAuthorized != null) {
      if (isAuthorized) {
        var phone = await Requests.getPrefs(
          key: Cache.phone,
          prefsType: PrefsType.string,
        );
        var pass = await Requests.getPrefs(
          key: Cache.pass,
          prefsType: PrefsType.string,
        );

        var authData = await Requests.auth(
          phone: phone,
          pass: pass,
        );
        if (authData is int) {
          // TODO: Обработка статус кодов != 200
        } else {
          await Future.delayed(const Duration(milliseconds: 400));

          Get.offNamed(
            Routes.general,
            arguments: authData,
          );
        }
      }else {
      await Future.delayed(const Duration(milliseconds: 400));
      Get.offNamed(Routes.auth);
    }
    } else {
      await Future.delayed(const Duration(milliseconds: 400));
      Get.offNamed(Routes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCalled) {
      _load();
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
