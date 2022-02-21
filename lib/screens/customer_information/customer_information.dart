import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/bottom_sheet.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInformationPage extends StatefulWidget {
  const CustomerInformationPage({
    Key? key,
    required this.clientType,
    this.isHandingButton = false,
    this.isFromNotification = false,
  }) : super(key: key);

  final ClientType clientType;
  final bool isHandingButton;
  final bool isFromNotification;

  @override
  _CustomerInformationPageState createState() =>
      _CustomerInformationPageState();
}

class _CustomerInformationPageState extends State<CustomerInformationPage> {
  late bool _isLoading;
  late GeneralController _controller;
  late ScrollController _scrollController;
  late bool _isOpenedBootomSheet;
  late double _currentPosition;
  late double _startPosition;
  late double _sensitivityFactor;
  late bool _isFromNotification;
  late String? _phone;

  @override
  void initState() {
    super.initState();
    _isFromNotification = widget.isFromNotification;
    _controller = Get.find<GeneralController>();
    _scrollController = ScrollController();
    _isOpenedBootomSheet = false;
    _currentPosition = 0.0;
    _startPosition = 0.0;
    _sensitivityFactor = 10;
    load();
  }

  Future<void> load() async {
    setState(() {
      _isLoading = true;
    });

    if (_isFromNotification) {
      _phone = Get.arguments;
      await ErrorHandler.loadingData(
        context: context,
        request: () {
          return _controller.getCustomerByPhone(phone: _phone.toString());
        },
      );
    }
    await ErrorHandler.loadingData(
      context: context,
      request: () {
        return _controller.getCustomerInfo(
            customerId: _controller.appState.value.currentCustomer!.uid);
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return SimpleGestureDetector(
      onHorizontalSwipe: _onHorizontalSwipe,
      onVerticalSwipe: _onVerticalSwipe,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(
          title: S.of(context).customer_information,
          isBackArrow: true,
          onBack: () async {
            _controller.appState.update((model) {
              model?.currentCustomer = null;
            });

            Get.back();

            await ErrorHandler.singleRequest(
              context: context,
              request: _controller.getCustomers,
              skipCheck: true,
              handler: (_) {
                CustomSnackbar.getSnackbar(
                  title: S.of(context).no_internet_access,
                  message: S.of(context).failed_update_list,
                );
              },
            );
          },
          onNotification: () {
            Get.toNamed(Routes.notifications);
          },
        ),
        body: !_isLoading
            ? _controller.appState.value.currentCustomer != null
                ? Column(
                    children: [
                      const SizedBox(height: 25),

                      /// Основная информация
                      DefaultContainer(
                        padding: const EdgeInsets.fromLTRB(15.5, 19, 5.5, 25),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            /// ФИО
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width - 90,
                                  child: Text(
                                    _controller.appState.value.currentCustomer!
                                        .fullName,
                                    style: theme.textTheme.bodyText1,
                                  ),
                                ),
                                if (widget.clientType != ClientType.conducted &&
                                    widget.clientType != ClientType.permanent &&
                                    widget.clientType != ClientType.sleeping)
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Images.more,
                                        width: 4,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!_isLoading) {
                                            _showBottomSheet();
                                          }
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
                              onTap: () async {
                                if (Platform.isIOS) {
                                  dynamic number = _controller
                                      .appState.value.currentCustomer!.phone
                                      .split(' ');
                                  number =
                                      '${number[0]}${number[1]}${number[2]}';
                                  number = number.split('(');
                                  number = '${number[0]}${number[1]}';
                                  number = number.split(')');
                                  number = '${number[0]}${number[1]}';
                                  number = number.split('+7');
                                  number = '8${number[1]}';
                                  log(number);
                                  await launch("tel://$number");
                                } else {
                                  await launch(
                                      "tel://${_controller.appState.value.currentCustomer!.phone}");
                                }
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
                                    _controller
                                        .appState.value.currentCustomer!.phone,
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
                      NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          /// Проверка на скролл вверх
                          if (notification.metrics.pixels - _currentPosition >=
                              _sensitivityFactor) {
                            /// Проверка, происходит ли скролл внизу, в пределах 20 пикселей
                            if (_startPosition >=
                                    _scrollController.position.maxScrollExtent -
                                        10 &&
                                _startPosition <=
                                    _scrollController.position.maxScrollExtent +
                                        10 &&
                                !_isOpenedBootomSheet) {
                              if (widget.clientType != ClientType.conducted &&
                                  widget.clientType != ClientType.permanent &&
                                  widget.clientType != ClientType.sleeping) {
                                _showBottomSheet();
                              }
                            }
                          }

                          if (notification is ScrollEndNotification) {
                            _startPosition = notification.metrics.pixels;
                          }
                          _currentPosition = notification.metrics.pixels;

                          return true;
                        },
                        child: Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                DefaultContainer(
                                  padding: const EdgeInsets.fromLTRB(
                                      28, 17.45, 19, 22.55),
                                  child: _controller.appState.value.detailedInfo
                                          .isNotEmpty
                                      ? ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _controller.appState.value
                                              .detailedInfo.length,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _controller
                                                      .appState
                                                      .value
                                                      .detailedInfo[index]
                                                      .header,
                                                  style:
                                                      theme.textTheme.headline3,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  _controller
                                                      .appState
                                                      .value
                                                      .detailedInfo[index]
                                                      .value,
                                                  style:
                                                      theme.textTheme.headline4,
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
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox()
            : const Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: widget.isHandingButton
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: CustomTextButton(
                  onTap: () {
                    Get.toNamed(Routes.trainerChoosing);
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
  Future<void> _showBottomSheet() async {
    setState(() {
      _isOpenedBootomSheet = true;
    });
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return CustomBottomSheet(clientType: widget.clientType);
      },
    );
    setState(() {
      _isOpenedBootomSheet = false;
    });
  }

  /// Переход в WhatsApp чат с клиентом
  Future<void> _switchingToChat(ThemeData theme) async {
    dynamic number;
    number = _controller.appState.value.currentCustomer!.phone.split(' ');
    number = '${number[0]}${number[1]}${number[2]}';
    number = number.split('(');
    number = '${number[0]}${number[1]}';
    number = number.split(')');
    number = '${number[0]}${number[1]}';
    String? greeting =
        _controller.appState.value.auth?.data?.whatsAppDefaultGreeting;
    if (greeting != null) {
      greeting = greeting.replaceAll('_CustomerName_',
          _controller.appState.value.currentCustomer!.firstName);
      greeting = greeting.replaceAll(
          '_TrainerName_', _controller.appState.value.auth!.users![0].name);
      greeting = greeting.replaceAll(
          '_ClubName_', _controller.appState.value.auth!.data!.clubName);
    }

    bool _isFromNewCustomers = _controller.appState.value
            .bottomBarItems[_controller.appState.value.currentIndex].uid ==
        Client.fresh;

    /// Открытие whatsapp для IOS
    if (Platform.isIOS) {
      tryLaunchWhatsapp(
        whatsappLink: 'https://wa.me/$number',
        text: '?text=$greeting',
        isFromNewCustomers: _isFromNewCustomers,
      );

      /// Открытие whatsapp для Android
    } else {
      tryLaunchWhatsapp(
        whatsappLink: 'whatsapp://send?phone=$number',
        text: '&text=$greeting',
        isFromNewCustomers: _isFromNewCustomers,
      );
    }
  }

  /// Открытие WhatsApp
  tryLaunchWhatsapp({
    required String whatsappLink,
    required bool isFromNewCustomers,
    required String? text,
  }) async {
    if (await canLaunch(whatsappLink)) {
      /// Если из новых, то с приветствием
      if (isFromNewCustomers) {
        await launch(whatsappLink + '$text');
      } else {
        await launch(whatsappLink);
      }
    } else {
      getErrorWhatsappLaunch;
    }
  }

  ///Уведомление об ошибке открытия WhatsApp
  get getErrorWhatsappLaunch {
    CustomSnackbar.getSnackbar(
      title: S.of(context).whatsapp_exeption,
      message: S.of(context).whatsapp_exeption_description,
    );
  }

  void _onHorizontalSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.right) {
      Get.back();
    }
  }

  void _onVerticalSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.up) {
      if (widget.clientType != ClientType.conducted &&
          widget.clientType != ClientType.permanent &&
          widget.clientType != ClientType.sleeping) {
        if (!_isLoading) {
          _showBottomSheet();
        }
      }
    }
  }
}
