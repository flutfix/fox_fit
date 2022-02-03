import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/text_button.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({
    Key? key,
    required this.image,
    required this.text,
    required this.textButton,
  }) : super(key: key);

  final String image;
  final String text;
  final String textButton;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).kickoff_training,
        isBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
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
              const SizedBox(height: 56),
              CustomTextButton(
                text: textButton,
                backgroundColor: theme.colorScheme.secondary,
                textStyle: theme.textTheme.button!,
              ),
              const SizedBox(height: 12),
              CustomTextButton(
                text: S.of(context).cancel,
                backgroundColor: theme.buttonTheme.colorScheme!.primary,
                textStyle: theme.textTheme.button!
                    .copyWith(color: theme.buttonTheme.colorScheme!.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
