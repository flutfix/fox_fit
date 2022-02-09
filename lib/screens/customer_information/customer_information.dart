import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/utils/snackbar.dart';
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
    this.isHandingButton = false,
  }) : super(key: key);

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
    controller = Get.find<GeneralController>();
    load();
    super.initState();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
    });

    await controller.getCustomerInfo(
        customerId: controller.appState.value.currentCustomer!.uid);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Swipe(
      onSwipeRight: () => Get.back(),
      onSwipeUp: () => _showBottomSheet(theme: theme),
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
            physics: const BouncingScrollPhysics(
                parent: NeverScrollableScrollPhysics()),
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
                          SizedBox(
                            width: width - 90,
                            child: Text(
                              controller
                                  .appState.value.currentCustomer!.fullName,
                              style: theme.textTheme.bodyText1,
                            ),
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
                                  _showBottomSheet(theme: theme);
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
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          launch(
                              "tel://${controller.appState.value.currentCustomer!.phone}");
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Images.phone,
                              width: 17,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.appState.value.currentCustomer!.phone,
                              style: theme.textTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      /// Переход в чат
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await _switchingToChat(theme);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.chat,
                              width: 20,
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
                    child: controller.appState.value.detailedInfo.isNotEmpty
                        ? ListView.separated(
                            itemCount:
                                controller.appState.value.detailedInfo.length,
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
                                    controller.appState.value
                                        .detailedInfo[index].header,
                                    style: theme.textTheme.headline3,
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 38,
                                    child: Text(
                                      controller.appState.value
                                          .detailedInfo[index].value,
                                      style: theme.textTheme.headline4,
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'Информация о клиенте отсутствует',
                              style: theme.textTheme.headline3,
                            ),
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
                  onTap: () {
                    Get.toNamed(Routes.trinerChoosing);
                  },
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

  Future<void> _switchingToChat(ThemeData theme) async {
    dynamic number;
    number = controller.appState.value.currentCustomer!.phone.split(' ');
    number = '${number[0]}${number[1]}${number[2]}';
    number = number.split('(');
    number = '${number[0]}${number[1]}';
    number = number.split(')');
    number = '${number[0]}${number[1]}';
    String? greeting =
        controller.appState.value.auth?.data?.whatsAppDefaultGreeting;
    if (greeting != null) {
      greeting = greeting.replaceAll('_CustomerName_',
          controller.appState.value.currentCustomer!.firstName);
      greeting = greeting.replaceAll(
          '_TrainerName_', controller.appState.value.auth!.users![0].name);
      greeting = greeting.replaceAll(
          '_ClubName_', controller.appState.value.auth!.data!.clubName);
    }

    await canLaunch('whatsapp://send?phone=$number')
        ? launch(
            'whatsapp://send?phone=$number&text=$greeting',
          )
        : Snackbar.getSnackbar(
            title: S.of(context).whatsapp_exeption,
            message: S.of(context).whatsapp_exeption_description,
          );
  }
}
