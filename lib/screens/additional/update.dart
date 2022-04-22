import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(65),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SvgPicture.asset(Images.foxUpdate),
                const SizedBox(height: 50),
                Text(
                  S.of(context).i_did_it,
                  style: theme.textTheme.headline1,
                ),
                const SizedBox(height: 19),
                Text(
                  S.of(context).update_soon,
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                CustomTextButton(
                  onTap: () {
                    if (Platform.isAndroid) {
                      launch(
                        'https://play.google.com/store/apps/details?id=com.foxfit.app.FoxFit',
                      );
                    }
                    if (Platform.isIOS) {
                      launch(
                        'https://apps.apple.com/ru/app/foxfit/id1563341149',
                      );
                    }
                  },
                  height: 51,
                  text: S.of(context).update,
                  backgroundColor: theme.colorScheme.secondary,
                  textStyle: theme.textTheme.button!,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
