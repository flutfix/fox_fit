import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/generated/l10n.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(60),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SvgPicture.asset(Images.foxError),
                const SizedBox(height: 50),
                Text(
                  S.of(context).even_everything_is_broken,
                  style: theme.textTheme.headline1,
                ),
                const SizedBox(height: 19),
                Text(
                  S.of(context).working_on_a_fix,
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
