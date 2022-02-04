import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/screens/general/general.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late TextEditingController phoneController;
  late TextEditingController passController;
  late MaskTextInputFormatter maskFormatter;

  @override
  void initState() {
    phoneController = TextEditingController();
    passController = TextEditingController();
    maskFormatter = MaskTextInputFormatter(
      mask: '+7 ###-###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
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

                    ///Ввод номера телефона
                    Input(
                      width: width,
                      // prefixText: '+7',
                      hintText: 'Введите телефон',
                      icon: Images.phone,
                      textInputType: TextInputType.phone,
                      textController: phoneController,
                      textInputAction: TextInputAction.next,
                      textFormatters: [maskFormatter],
                      scrollPaddingBottom: 120,
                    ),
                    const SizedBox(height: 18),

                    ///Ввод пароля
                    Input(
                      width: width,
                      hintText: 'Введите пароль',
                      icon: Images.pass,
                      obscureText: true,
                      textController: passController,
                    ),
                    const SizedBox(height: 46),

                    ///Кнопка [Войти]
                    CustomTextButton(
                      width: width,
                      text: S.of(context).log_in,
                      onTap: () async {
                        if (phoneController.text.isNotEmpty &&
                            passController.text.isNotEmpty) {
                          var authData = await Requests.auth(
                            phone: maskFormatter.getUnmaskedText(),
                            pass: passController.text,
                          );
                          bool? isAuthorized = await Requests.getPrefs(
                              key: Cashe.isAuthorized,
                              prefsType: PrefsType.boolean);
                          if (isAuthorized != null) {
                            if (isAuthorized) {
                              log('[Auth] User was authorized');
                              Get.offNamed(
                                Routes.general,
                                arguments: authData,
                              );
                            }
                          }
                        }
                      },
                      backgroundColor: theme.colorScheme.secondary,
                      textStyle: theme.textTheme.button!.copyWith(),
                    ),
                    const SizedBox(height: 60)
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
