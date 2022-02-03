import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';

class ConfirmationPage extends StatelessWidget {
  ConfirmationPage({
    Key? key,
    required this.image,
    required this.text,
    this.padding = const EdgeInsets.fromLTRB(20, 150, 20, 20),
  }) : super(key: key);

  final String image;
  final String text;
  final EdgeInsetsGeometry padding;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: padding,
          child: DefaultContainer(
            padding: const EdgeInsets.all(45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  image,
                  width: 42,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 30),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headline5,
                ),
                const SizedBox(height: 12),
                Input(
                  textController: controller,
                  hintText: S.of(context).comment_for_recipient,
                  hintStyle: theme.textTheme.bodyText2,
                  textStyle: theme.textTheme.bodyText2,
                  cursorColor: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                  padding: const EdgeInsets.all(5),
                  textCapitalization: TextCapitalization.sentences,
                  lines: 3,
                ),
                const SizedBox(height: 12),
                CustomTextButton(
                  text: S.of(context).confirm,
                  backgroundColor: theme.colorScheme.secondary,
                  textStyle: theme.textTheme.button!,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: CustomTextButton(
                    text: S.of(context).cancel,
                    backgroundColor: theme.buttonTheme.colorScheme!.primary,
                    textStyle: theme.textTheme.button!.copyWith(
                        color: theme.buttonTheme.colorScheme!.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
