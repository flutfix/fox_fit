import 'package:flutter/material.dart';
import 'package:fox_fit/api/requests.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
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
  late MaskTextInputFormatter maskFormatter;
  late bool isPhoneAnimation;
  late bool isPassAnimation;
  late String oldPhone;

  @override
  void initState() {
    oldPhone = '';
    phoneController = TextEditingController();
    passController = TextEditingController();
    maskFormatter = MaskTextInputFormatter(
      mask: '+7 ###-###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    isPhoneAnimation = false;
    isPassAnimation = false;
    getPhoneFromPrefs();
    super.initState();
  }

  /// [Rive Animation]
  // _initRiveAnimation() async {
  //   await rootBundle.load(Animations.testAnimation).then(
  //     (data) async {
  //       // Load the RiveFile from the binary data.
  //       final file = RiveFile.import(data);
  //       final artboard = file.mainArtboard;
  //       artboard.addController(
  //           _animationcontroller = SimpleAnimation('Light', autoplay: false));
  //       // ignore: cascade_invocations

  //       setState(() => _riveArtboard = artboard);
  //     },
  //   );
  // }

  Future<dynamic> getPhoneFromPrefs() async {
    var phone =
        await Requests.getPrefs(key: Cashe.phone, prefsType: PrefsType.string);
    if (phone != null) {
      if (phone != '') {
        setState(() {
          oldPhone = phone;
          phoneController.text = maskFormatter.maskText(phone);
        });
      }
    }
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

                    /// Ввод номера телефона
                    Input(
                      width: width,
                      hintText: 'Введите телефон',
                      icon: Images.phone,
                      isIconAnimation: isPhoneAnimation,
                      textInputType: TextInputType.phone,
                      textController: phoneController,
                      textInputAction: TextInputAction.next,
                      textFormatters: [maskFormatter],
                      scrollPaddingBottom: 120,
                    ),
                    const SizedBox(height: 18),

                    /// Ввод пароля
                    Input(
                      width: width,
                      hintText: 'Введите пароль',
                      icon: Images.pass,
                      isIconAnimation: isPassAnimation,
                      obscureText: true,
                      textController: passController,
                    ),
                    const SizedBox(height: 46),

                    /// Кнопка [Войти]
                    CustomTextButton(
                      width: width,
                      text: S.of(context).log_in,
                      onTap: () async {
                        // _togglePlay();
                        await _validateFields(theme);
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

  Future<dynamic> _validateFields(ThemeData theme) async {
    if (phoneController.text.isNotEmpty && passController.text.isNotEmpty) {
      var authData = await Requests.auth(
        phone: oldPhone != '' ? oldPhone : maskFormatter.getUnmaskedText(),
        pass: passController.text,
      );
      if (authData is int) {
        if (authData == 401) {
          Get.snackbar(
            S.of(context).login_exeption,
            S.of(context).wrong_login_or_pass,
            duration: const Duration(seconds: 2),
            backgroundColor: theme.canvasColor,
            colorText: Styles.greyLight,
            boxShadows: [
              BoxShadow(
                color: Styles.black.withOpacity(0.10),
                offset: const Offset(0, 4),
                blurRadius: 15,
              )
            ],
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        
      } else {
        Get.offAllNamed(
          Routes.general,
          arguments: authData,
        );
      }
    } else {
      if (phoneController.text.isEmpty && passController.text.isEmpty) {
        setState(() {
          isPhoneAnimation = true;
          isPassAnimation = true;
        });
        await Future.delayed(const Duration(milliseconds: 250));
        setState(() {
          isPhoneAnimation = false;
          isPassAnimation = false;
        });
      } else {
        if (phoneController.text.isEmpty) {
          setState(() {
            isPhoneAnimation = true;
          });
          await Future.delayed(const Duration(milliseconds: 250));
          setState(() {
            isPhoneAnimation = false;
          });
        }
        if (passController.text.isEmpty) {
          setState(() {
            isPassAnimation = true;
          });
          await Future.delayed(const Duration(milliseconds: 250));
          setState(() {
            isPassAnimation = false;
          });
        }
      }
    }
  }
}
