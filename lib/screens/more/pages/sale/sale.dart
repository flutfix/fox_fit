import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/routes.dart';
import 'package:fox_fit/controllers/sales_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/animation.dart';
import 'package:fox_fit/widgets/animated_container.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({Key? key}) : super(key: key);

  @override
  _CreateSalePageState createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  late SalesController _salesController;
  @override
  void initState() {
    _salesController = Get.put(SalesController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () {
        // _salesController.clear(appointment: true);
        Get.back();
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: CustomAppBar(
          title: S.of(context).sales,
          isBackArrow: true,
          isNotification: false,
          onBack: () {
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
          child: Column(
            children: [
              ///[Тип продажи]
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    /// Персональная
                    Obx(
                      () => CustomAnimatedContainer(
                        text: S.of(context).personalka,
                        isActive: _salesController.state.value.isPersonal
                            ? true
                            : false,
                        animation:
                            AnimationModel(activeWidth: 120, inactiveWidth: 96),
                        wrapText: false,
                        onTap: () {
                          _salesController.state.update((model) {
                            model?.isPersonal = true;
                          });
                        },
                      ),
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
                        isActive: _salesController.state.value.isPersonal
                            ? false
                            : true,
                        wrapText: false,
                        onTap: () {
                          _salesController.state.update((model) {
                            model?.isPersonal = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Выбор клиента
              const SizedBox(height: 12),
              CustomAnimatedContainer(
                text: S.of(context).select_client,
                onTap: () {
                  Get.toNamed(Routes.selectClient);
                },
                // onCheckBox: (activeCheckbox) {
                //   _scheduleController.state.update((model) {
                //     model?.clients[0].arrivalStatus = activeCheckbox;
                //   });
                // },
              ),

              /// Длительность
              const SizedBox(height: 12),
              CustomAnimatedContainer(
                text: S.of(context).duration,
                onTap: () {},
              ),

              ///[Тип Персональной тренировки]
              Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: _salesController.state.value.isPersonal ? 12 : 0)),
              _animatedVisible(
                context,
                child: Row(
                  children: [
                    /// Персональная
                    Obx(
                      () => CustomAnimatedContainer(
                        text: S.of(context).personal,
                        isActive: _salesController.state.value.personalType
                            ? false
                            : true,
                        animation: AnimationModel(activeWidth: 144),
                        wrapText: false,
                        onTap: () {
                          _salesController.state.update((model) {
                            model?.personalType = false;
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
                        isActive: _salesController.state.value.personalType
                            ? true
                            : false,
                        wrapText: false,
                        onTap: () {
                          _salesController.state.update((model) {
                            model?.personalType = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Услуга
              const SizedBox(height: 12),
              CustomAnimatedContainer(
                text: S.of(context).service,
                onTap: () {},
              ),

              ///[Продление или стартовая]
              Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: _salesController.state.value.isPersonal ? 12 : 0)),
              _animatedVisible(
                context,
                child: Row(
                  children: [
                    /// Продление
                    Obx(
                      () => CustomAnimatedContainer(
                        text: S.of(context).extension_sale,
                        isActive: _salesController.state.value.isStarting
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
                        isActive: _salesController.state.value.isStarting
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

              /// Количество
              const SizedBox(height: 12),
              CustomAnimatedContainer(
                text: S.of(context).quantity,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Obx _animatedVisible(
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
}
