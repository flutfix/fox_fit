import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/widgets/bottom_sheet.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInformationPage extends StatefulWidget {
  const CustomerInformationPage({
    Key? key,
    required this.customer,
    this.isHandingButton = false,
  }) : super(key: key);

  final CustomerModel customer;
  final bool isHandingButton;

  @override
  _CustomerInformationPageState createState() =>
      _CustomerInformationPageState();
}

class _CustomerInformationPageState extends State<CustomerInformationPage> {
  late bool loading;
  late GeneralController controller;

  @override
  void initState() {
    controller = Get.put(GeneralController());
    load();
    super.initState();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
    });

    await controller.getCustomerInfo(clientUid: widget.customer.uid);

    setState(() {
      loading = false;
    });
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
          title: S.of(context).customer_information,
          isBackArrow: true,
          onBack: () {
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 25),


                /// Основная информация
                DefaultContainer(
                  padding: const EdgeInsets.fromLTRB(15.5, 19, 5.5, 25),
                  child: Column(
                    children: [
                      /// ФИО
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.customer.fullName,
                            style: theme.textTheme.bodyText1,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                Images.more,
                                width: 4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showBottomSheet(theme: theme);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      /// Номер телефона
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Images.phone,
                            width: 17,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.customer.phone,
                            style: theme.textTheme.headline2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      /// Переход в чат
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await _switchingToChat();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Images.chat,
                              width: 17,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              S.of(context).chat,
                              style: theme.textTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// Подробная инфромация о клиенте
                /// [Цели], [Травмы], [Пожелания], [Комментарии], [Дата рождения]
                if (loading)
                  const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                else
                  DefaultContainer(
                    padding: const EdgeInsets.fromLTRB(28, 17.45, 19, 22.55),
                    child: ListView.separated(
                      itemCount: controller.appState.value.detailedInfo.length,
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
                              controller
                                  .appState.value.detailedInfo[index].header,
                              style: theme.textTheme.headline3,
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 38,
                              child: Text(
                                controller
                                    .appState.value.detailedInfo[index].value,
                                style: theme.textTheme.headline4,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButton: widget.isHandingButton
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: CustomTextButton(
                  height: 51,
                  text: S.of(context).send_to_trainer,
                  backgroundColor: theme.colorScheme.secondary,
                  textStyle: theme.textTheme.button!,
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  /// Открывает нижлий лист с доступными вариантами
  /// передачи клиента дальше по воронке
  void _showBottomSheet({required ThemeData theme}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CustomBottomSheet();
      },
    );
  }

  Future<void> _switchingToChat() async {
    dynamic number;
    number = widget.customer.phone.split(' ');
    number = '${number[0]}${number[1]}${number[2]}';
    number = number.split('(');
    number = '${number[0]}${number[1]}';
    number = number.split(')');
    number = '${number[0]}${number[1]}';

    await canLaunch('whatsapp://send?phone=$number')
        ? launch(
            'whatsapp://send?phone=$number&text=${widget.customer.firstName}, здравствуйте! Меня зовут Андрей,'
            ' я являюсь персональным тренером фитнес-клуба X-fit «Южный лёд».'
            'Вы записались на вводную персональную тренировку, и я пишу, чтобы'
            ' договориться о дате и времени. Напишите, пожалуйста, когда вам будет удобно?',
          )
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }
}
