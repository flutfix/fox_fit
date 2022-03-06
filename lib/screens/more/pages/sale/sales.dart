import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/sales_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/animation.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_client.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/utils/picker/picker.dart';
import 'package:fox_fit/widgets/animated_container.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:fox_fit/widgets/text_button.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({Key? key}) : super(key: key);

  @override
  _CreateSalePageState createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  late GeneralController _generalController;
  late SalesController _salesController;
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = false;
    _generalController = Get.find<GeneralController>();
    _salesController = Get.put(SalesController());
    _load();
    super.initState();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
    });
    await ErrorHandler.request(
      context: context,
      request: () {
        return _salesController.getAppointmentsDurations(
          userUid: _generalController.getUid(
            role: UserRole.trainer,
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(
          title: S.of(context).sales,
          isBackArrow: true,
          isNotification: false,
          onBack: () {
            Get.back();
          },
        ),
        body: !_isLoading
            ? Padding(
                padding: const EdgeInsets.only(bottom: 110.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 75),
                    child: Column(
                      children: [
                        ///[Тип продажи]
                        _personalOrGroup(
                          context,
                          onPersonal: () {
                            _salesController.state.update((model) {
                              model?.isPersonal = true;
                            });
                          },
                          onGroup: () {
                            _salesController.state.update((model) {
                              model?.isPersonal = false;
                            });
                          },
                        ),

                        /// [Выбор клиента]
                        const SizedBox(height: 12),
                        Obx(
                          () => CustomAnimatedContainer(
                            text: chooseClientButtonText(),
                            onTap: () {
                              Get.to(
                                () => const SelectClientPage(isFromSale: true),
                              );
                            },
                          ),
                        ),

                        /// [Длительность]
                        const SizedBox(height: 12),
                        Obx(
                          () => CustomAnimatedContainer(
                            text: _salesController.state.value.chosenDuration !=
                                    null
                                ? _salesController.state.value.chosenDuration
                                    .toString()
                                : S.of(context).duration,
                            onTap: () async {
                              await Picker.custom(
                                  context: context,
                                  values:
                                      _salesController.state.value.durations,
                                  currentValue: _salesController
                                      .state.value.chosenDuration,
                                  borderRadius: BorderRadius.zero,
                                  onConfirm: (value) {
                                    _salesController.state.update((val) {
                                      val?.chosenDuration = value;
                                    });
                                  });
                            },
                          ),
                        ),

                        ///[Тип Персональной тренировки]
                        Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: _salesController.state.value.isPersonal
                                ? 12
                                : 0)),
                        _animatedVisible(
                          context,
                          child: Row(
                            children: [
                              /// Персональная
                              Obx(
                                () => CustomAnimatedContainer(
                                  text: S.of(context).personal,
                                  isActive: _salesController.state.value.isSplit
                                      ? false
                                      : true,
                                  animation: AnimationModel(activeWidth: 144),
                                  wrapText: false,
                                  onTap: () {
                                    _salesController.state.update((model) {
                                      model?.isSplit = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 7),

                              /// Сплит
                              Obx(
                                () => CustomAnimatedContainer(
                                  text: S.of(context).split,
                                  animation: AnimationModel(
                                    activeWidth: 77,
                                    inactiveWidth: 60,
                                  ),
                                  isActive: _salesController.state.value.isSplit
                                      ? true
                                      : false,
                                  wrapText: false,
                                  onTap: () {
                                    _salesController.state.update((model) {
                                      model?.isSplit = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// [Услуга]
                        const SizedBox(height: 12),
                        Obx(
                          () => CustomAnimatedContainer(
                            text: (_salesController
                                        .state.value.currentService !=
                                    null)
                                ? _salesController
                                    .state.value.currentService!.name
                                : S.of(context).service,
                            onTap: () {
                              if (_salesController.state.value.chosenDuration !=
                                  null) {
                                Get.toNamed(Routes.saleServices);
                              } else {
                                CustomSnackbar.getSnackbar(
                                  title: S.of(context).set_duration,
                                );
                              }
                            },
                          ),
                        ),

                        ///[Продление или стартовая]
                        Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: _salesController.state.value.isPersonal
                                ? 12
                                : 0)),
                        _animatedVisible(
                          context,
                          child: Row(
                            children: [
                              /// Продление
                              Obx(
                                () => CustomAnimatedContainer(
                                  text: S.of(context).extension_sale,
                                  isActive:
                                      _salesController.state.value.isStarting
                                          ? false
                                          : true,
                                  animation: AnimationModel(
                                    activeWidth: 114,
                                    inactiveWidth: 90,
                                  ),
                                  wrapText: false,
                                  onTap: () {
                                    _salesController.state.update((model) {
                                      model?.isStarting = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 7),

                              /// Стартовая
                              Obx(
                                () => CustomAnimatedContainer(
                                  text: S.of(context).starting,
                                  animation: AnimationModel(
                                    activeWidth: 111,
                                    inactiveWidth: 90,
                                  ),
                                  isActive:
                                      _salesController.state.value.isStarting
                                          ? true
                                          : false,
                                  wrapText: false,
                                  onTap: () {
                                    _salesController.state.update((model) {
                                      model?.isStarting = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// [Количество]
                        const SizedBox(height: 12),
                        Obx(
                          () => CustomAnimatedContainer(
                            text: _salesController.state.value.quantity != null
                                ? _salesController.state.value.quantity!
                                    .toString()
                                : S.of(context).quantity,
                            onTap: () async {
                              await Picker.custom(
                                  context: context,
                                  values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                  currentValue:
                                      _salesController.state.value.quantity,
                                  borderRadius: BorderRadius.zero,
                                  onConfirm: (value) {
                                    _salesController.state.update((model) {
                                      model?.quantity = value;
                                    });
                                  });
                            },
                          ),
                        ),

                        /// Список клиентов для групповой
                        Obx(
                          () {
                            if (!_salesController.state.value.isPersonal) {
                              return Column(
                                  children: List.generate(
                                      _salesController
                                          .state.value.clients.length, (index) {
                                String customerName = _salesController
                                    .state.value.clients[index].fullName;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: CustomAnimatedContainer(
                                    text: customerName,
                                    isButtonDelete: true,
                                    onTap: () {},
                                    onDelete: () {
                                      _salesController.state.update(
                                        (model) {
                                          model?.clients.removeAt(index);
                                        },
                                      );
                                    },
                                  ),
                                );
                              }));
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),

        /// Нижний блок - Выставление продажи
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                if (_salesController.state.value.currentService != null) {
                  if (_salesController.state.value.quantity != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 12),

                      /// Сумма продажи
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: _sumarryAmountFormat(),
                            style: theme.textTheme.headline1,
                          ),
                          TextSpan(
                            text: ' ${S.of(context).currency_symbol}',
                            style: theme.textTheme.headline1!.copyWith(
                              fontFamily: Styles.robotoFamily,
                            ),
                          )
                        ]),
                      ),
                    );
                  }
                }
                return const SizedBox();
              }),

              /// Выставить продажу
              CustomTextButton(
                height: 51,
                text: S.of(context).expose_sell,
                backgroundColor: theme.colorScheme.secondary,
                textStyle: theme.textTheme.button!,
                onTap: () {
                  if (_salesController.state.value.clients.isNotEmpty) {
                    if (_salesController.state.value.currentService != null) {
                      if (_salesController.state.value.quantity != null) {
                      } else {
                        _getSnackbar;
                      }
                    } else {
                      _getSnackbar;
                    }
                  } else {
                    _getSnackbar;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Выбор типа тренировки
  Widget _personalOrGroup(
    BuildContext context, {
    required Function() onPersonal,
    required Function() onGroup,
  }) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          /// Персональная
          Obx(
            () => CustomAnimatedContainer(
                text: S.of(context).personalka,
                isActive:
                    _salesController.state.value.isPersonal ? true : false,
                animation: AnimationModel(activeWidth: 120, inactiveWidth: 96),
                wrapText: false,
                onTap: onPersonal),
          ),
          const SizedBox(width: 7),

          /// Групповая
          Obx(
            () => CustomAnimatedContainer(
              text: S.of(context).group,
              animation: AnimationModel(
                activeWidth: 80,
                inactiveWidth: 70,
              ),
              isActive: _salesController.state.value.isPersonal ? false : true,
              wrapText: false,
              onTap: onGroup,
            ),
          ),
        ],
      ),
    );
  }

  /// Анимированные контейнеры, для полей, которых нет в групповой трене
  Widget _animatedVisible(
    BuildContext context, {
    required Widget child,
    int duration = 250,
    Curve curve = Curves.linear,
  }) {
    return Obx(
      () => AnimatedOpacity(
        duration: Duration(milliseconds: (duration * 0.75).toInt()),
        curve: curve,
        opacity: _salesController.state.value.isPersonal ? 1.0 : 0.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: duration),
          curve: curve,
          height: _salesController.state.value.isPersonal ? 60 : 0,
          child: child,
        ),
      ),
    );
  }

  void get _getSnackbar {
    return CustomSnackbar.getSnackbar(
      title: S.of(context).fill_previous_fields,
    );
  }

  String chooseClientButtonText() {
    if (_salesController.state.value.isPersonal) {
      if (_salesController.state.value.clients.isNotEmpty) {
        return _salesController.state.value.clients[0].fullName;
      } else {
        return S.of(context).select_client;
      }
    } else {
      return S.of(context).select_client;
    }
  }

  /// Приведение к формату итоговой суммы, где тысячные отдельно
  String _sumarryAmountFormat() {
    dynamic amount = _salesController.state.value.currentService!.price *
        _salesController.state.value.quantity!;

    if (amount >= 1000) {
      var thousands = amount ~/ 1000;
      dynamic hundreds = amount % 1000;
      if (hundreds < 100) {
        if (hundreds == 0) {
          hundreds = '0$hundreds';
        }
        hundreds = '0$hundreds';
      }
      return '${S.of(context).amount}: $thousands $hundreds';
    }
    return '${S.of(context).amount}: $amount';
  }
}
