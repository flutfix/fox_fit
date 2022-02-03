import 'package:flutter/material.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
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

  @override
  void initState() {
    phoneController = TextEditingController();
    passController = TextEditingController();

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
                      hintText: '+7 ___-___-__-__',
                      icon: Images.phone,
                      textInputType: TextInputType.phone,
                      textController: phoneController,
                      textInputAction: TextInputAction.next,
                      textFormatters: [
                        MaskTextInputFormatter(
                          mask: '+7 ###-###-##-##',
                          filter: {"#": RegExp(r'[0-9]')},
                        )
                      ],
                      scrollPaddingBottom: 120,
                    ),
                    const SizedBox(height: 18),

                    ///Ввод пароля
                    Input(
                      width: width,
                      hintText: '*** *** ***',
                      icon: Images.pass,
                      obscureText: true,
                      textController: passController,
                    ),
                    const SizedBox(height: 46),

                    ///Кнопка [Войти]
                    CustomTextButton(
                      width: width,
                      text: S.of(context).log_in,
                      onTap: () {
                        Get.offNamed(Routes.general);
                      },
                      backgroundColor: theme.colorScheme.secondary,
                      textStyle: theme.textTheme.button!.copyWith(),
                    )
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
