import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/utils/snackbar.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe/swipe.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late GeneralController _controller;
  late TextEditingController _newPassController;
  late TextEditingController _newPassAgainController;
  late bool _isNewPassAnimation;
  late bool _isNewPassAgainAnimation;
  late bool _isCanVibrate;

  @override
  void initState() {
    _controller = Get.find<GeneralController>();
    _newPassController = TextEditingController();
    _newPassAgainController = TextEditingController();
    _isNewPassAnimation = false;
    _isNewPassAgainAnimation = false;
    _isCanVibrate = _controller.appState.value.isCanVibrate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () => Get.back(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(
          title: S.of(context).changing_password,
          isBackArrow: true,
          isNotification: false,
          onBack: () {
            Get.back();
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                S.of(context).description_changing_password,
                style: theme.textTheme.bodyText1,
              ),
              Divider(color: theme.dividerColor),

              /// Ввод нового пароля
              Input(
                isBorder: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
                hintText: S.of(context).new_password,
                icon: Images.passSvg,
                isIconAnimation: _isNewPassAnimation,
                textController: _newPassController,
                textInputAction: TextInputAction.next,
                scrollPaddingBottom: 120,
              ),
              Divider(color: theme.dividerColor),

              /// Ввод нового пароля (повторно)
              Input(
                isBorder: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
                hintText: S.of(context).new_password_again,
                icon: Images.passSvg,
                isIconAnimation: _isNewPassAgainAnimation,
                textController: _newPassAgainController,
                scrollPaddingBottom: 120,
              ),
              Divider(color: theme.dividerColor),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: CustomTextButton(
            onTap: () {
              _validateFields(theme);
            },
            height: 51,
            text: S.of(context).change_password,
            backgroundColor: theme.colorScheme.secondary,
            textStyle: theme.textTheme.button!,
          ),
        ),
      ),
    );
  }

  Future<dynamic> _validateFields(ThemeData theme) async {
    if (_newPassController.text.isEmpty &&
        _newPassAgainController.text.isEmpty) {
      if (_isCanVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }

      setState(() {
        _isNewPassAnimation = true;
        _isNewPassAgainAnimation = true;
      });
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _isNewPassAnimation = false;
        _isNewPassAgainAnimation = false;
      });
    } else if (_newPassController.text.isEmpty) {
      if (_isCanVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }

      setState(() {
        _isNewPassAnimation = true;
      });
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _isNewPassAnimation = false;
      });
    } else if (_newPassAgainController.text.isEmpty) {
      if (_isCanVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }

      setState(() {
        _isNewPassAgainAnimation = true;
      });
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _isNewPassAgainAnimation = false;
      });
    } else if (_newPassController.text.length < 3 ||
        _newPassAgainController.text.length < 3) {
      if (_isCanVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }

       CustomSnackbar.getSnackbar(
        title: S.of(context).data_entered_incorrectly,
        message: S.of(context).least_three_characters,
      );
    } else if (_newPassController.text != _newPassAgainController.text) {
      if (_isCanVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      CustomSnackbar.getSnackbar(
        title: S.of(context).passwords_do_not_match,
        message: S.of(context).repeat_input,
      );
    } else {
      // log('${_controller.appState.value.auth!.data!.licenseKey}');
      // log('${_controller.appState.value.auth!.users![0].uid}');
      // log('${_newPassAgainController.text}');
      var data = await _controller.changeUserPassword(
        key: _controller.appState.value.auth!.data!.licenseKey,
        userUid: _controller.appState.value.auth!.users![0].uid,
        newPass: _newPassAgainController.text,
      );
      if (data == 200) {
        /// Вибрация при успешной смене пароля
        if (_isCanVibrate) {
          Vibrate.feedback(FeedbackType.light);
        }
        Get.delete<GeneralController>();
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool(Cache.isAuthorized, false);
        prefs.setString(Cache.pass, '');

        Get.offAllNamed(Routes.auth);
      } else {
        if (_isCanVibrate) {
          Vibrate.feedback(FeedbackType.success);
        }
        CustomSnackbar.getSnackbar(
          title: S.of(context).server_error,
          message: S.of(context).password_not_changed,
        );
      }
    }
  }
}
