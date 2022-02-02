import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/utils/sizes.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';

class CustomerInformationPage extends StatefulWidget {
  const CustomerInformationPage({Key? key}) : super(key: key);

  @override
  _CustomerInformationPageState createState() =>
      _CustomerInformationPageState();
}

class _CustomerInformationPageState extends State<CustomerInformationPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).customer_information,
        isBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: Sizes.getHeightColumnForScroll(
              context: context,
              withBottomBar: false,
            ),
            child: Column(
              children: [
                const SizedBox(height: 25),

                /// ФИО и номер телефона
                DefaultContainer(
                  padding: const EdgeInsets.fromLTRB(15.5, 19, 15.5, 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //TODO: Привязать модель
                          Text(
                            'Сантанова Юлия Игоревна',
                            style: theme.textTheme.bodyText1,
                          ),
                          SvgPicture.asset(
                            Images.more,
                            width: 4,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          //TODO: Привязать модель
                          Text(
                            '+7 926 544 72 46',
                            style: theme.textTheme.headline2,
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            Images.phoneFill,
                            width: 23,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// Подробная инфромация о клиенте
                /// [Цели], [Травмы], [Пожелания], [Комментарии], [Дата рождения]
                DefaultContainer(
                  padding: const EdgeInsets.fromLTRB(28, 17.45, 19, 22.55),
                  //TODO: Привязать модель ко всему листу
                  child: ListView.separated(
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(height: 21),
                          Divider(
                            height: 1,
                            color: theme.dividerColor,
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Цели:',
                            style: theme.textTheme.headline3,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 38,
                            child: Text(
                              'Набор мышечной массы. Тренировки по плаванью.',
                              style: theme.textTheme.headline4,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}