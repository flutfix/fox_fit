import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/auth_data.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/prefs.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late TextEditingController phoneController;
  late TextEditingController passController;
  late MaskTextInputFormatter maskFormatter;
  late bool isPhoneAnimation;
  late bool isPassAnimation;
  late String oldPhone;
  late bool _loading;
  late bool _canVibrate;
  late FocusNode _phoneFocus;
  late String _phonePrefix;

  @override
  void initState() {
    _phoneFocus = FocusNode();
    _phonePrefix = '+7 ';
    oldPhone = '';
    _loading = false;
    _canVibrate = false;
    phoneController = TextEditingController();
    passController = TextEditingController();
    maskFormatter = MaskTextInputFormatter(
      mask: '+7 ###-###-##-##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    );
    isPhoneAnimation = false;
    isPassAnimation = false;
    getPhoneFromPrefs();
    initVibration();
    _phoneFocus.addListener(_onFocusChange);
    super.initState();
  }

  /// Подставление [+7] в начало строки, если поле в фокусе
  void _onFocusChange() {
    debugPrint("Focus: ${_phoneFocus.hasFocus.toString()}");
    if (_phoneFocus.hasFocus) {
      if (phoneController.text.isEmpty) {
        phoneController.text = _phonePrefix;
      }
    } else {
      if (phoneController.text == _phonePrefix) {
        phoneController.clear();
      }
    }
  }

  Future<void> initVibration() async {
    setState(() {
      _loading = true;
    });

    _canVibrate = await Vibrate.canVibrate;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    if (_loading) {
      return const SizedBox();
    } else {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: theme.backgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ///TopBar с лого
                Image.asset(
                  Images.authTop,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 47.0, right: 48.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 67),

                      /// Ввод номера телефона
                      Input(
                        width: width,
                        hintText: 'Введите телефон',
                        iconSvg: Images.phone,
                        isIconAnimation: isPhoneAnimation,
                        textInputType: TextInputType.phone,
                        textController: phoneController,
                        textInputAction: TextInputAction.next,
                        textFormatters: [maskFormatter],
                        scrollPaddingBottom: 120,
                        focusNode: _phoneFocus,
                        onChanged: (text) {
                          if (maskFormatter.getUnmaskedText().isEmpty) {
                            phoneController.value = TextEditingValue(
                              text: _phonePrefix,
                              selection: TextSelection.collapsed(
                                offset: _phonePrefix.length,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 18),

                      /// Ввод пароля
                      Input(
                        width: width,
                        hintText: 'Введите пароль',
                        iconSvg: Images.passSvg,
                        isIconAnimation: isPassAnimation,
                        obscureText: true,
                        textController: passController,
                        onEditingComplete: () async {
                          await _validateFields(theme);
                        },
                      ),
                      const SizedBox(height: 46),

                      /// Кнопка [Войти]
                      CustomTextButton(
                        width: width,
                        text: S.of(context).log_in,
                        onTap: () async {
                          await _validateFields(theme);
                        },
                        backgroundColor: theme.colorScheme.secondary,
                        textStyle: theme.textTheme.button!.copyWith(),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<dynamic> _validateFields(ThemeData theme) async {
    if (phoneController.text.isNotEmpty && passController.text.isNotEmpty) {
      dynamic data = await ErrorHandler.request(
        context: context,
        repeat: false,
        request: () {
          return Requests.auth(
            phone: maskFormatter.getUnmaskedText() == ''
                ? oldPhone
                : maskFormatter.getUnmaskedText(),
            pass: passController.text,
          );
        },
        handler: (data) async {
          CustomSnackbar.getSnackbar(
            title: S.of(context).server_error,
            message: S.of(context).authorization_failed,
          );

          return false;
        },
      );
      if (data is AuthDataModel) {
        /// Вибрация при успешной авторизации
        if (_canVibrate) {
          Vibrate.feedback(FeedbackType.light);
        }

        /// Для идентификации API зазпросов
        final String pathToBase = '${data.data!.pathToBase}hs/api_v1/';
        final String login = _getStringFromBase(text: data.data!.hashL);
        final String pass = _getStringFromBase(text: data.data!.hashP);
        _setPrefs(
          pathToBase: pathToBase,
          baseAuth: _getBase64String(text: '$login:$pass'),
        );
        Requests.url = pathToBase;
        Requests.options = BaseOptions(
          baseUrl: pathToBase,
          contentType: Headers.jsonContentType,
          headers: {
            HttpHeaders.authorizationHeader:
                'Basic ${_getBase64String(text: '$login:$pass')}',
          },
          connectTimeout: 10000,
          receiveTimeout: 10000,
        );

        ///--

        Get.offAllNamed(
          Routes.general,
          arguments: data,
        );
      }
    } else {
      /// Вибрация на незаполненные поля
      if (_canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      if (phoneController.text.isEmpty || passController.text.isEmpty) {
        setState(() {
          if (phoneController.text.isEmpty) {
            isPhoneAnimation = true;
          }
          if (passController.text.isEmpty) {
            isPassAnimation = true;
          }
        });
        await Future.delayed(const Duration(milliseconds: 250));
        setState(() {
          isPhoneAnimation = false;
          isPassAnimation = false;
        });
      }
    }
  }

  Future<dynamic> getPhoneFromPrefs() async {
    var phone =
        await Prefs.getPrefs(key: Cache.phone, prefsType: PrefsType.string);
    if (phone != null && phone != '') {
      setState(() {
        oldPhone = phone;
        phoneController.text = maskFormatter.maskText(phone);
      });
    }
  }

  static Future<void> _setPrefs({
    required String pathToBase,
    required String baseAuth,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Cache.pathToBase, pathToBase);
    prefs.setString(Cache.baseAuth, baseAuth);
  }

  static String _getBase64String({required String text}) {
    final bytes = utf8.encode(text);
    return base64Encode(bytes);
  }

  static String _getStringFromBase({required String text}) {
    final String first = utf8.decode(base64Decode(text));
    return utf8.decode(base64Decode(first));
  }

  @override
  void dispose() {
    super.dispose();
    _phoneFocus.removeListener(_onFocusChange);
    _phoneFocus.dispose();
  }
}
