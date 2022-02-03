import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/screens/confirmation/confirmation.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:get/get.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;
  final GeneralController controller = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),

          /// Разделитель
          Container(
            height: 5,
            width: 135,
            decoration: BoxDecoration(
              color:
                  theme.bottomSheetTheme.modalBackgroundColor!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 25),

          /// Основной контент
          if (child != null)
            child!
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: Column(
                children: [
                  ...List.generate(
                    controller.appState.value.availablePipelineStages.length,
                    (index) {
                      var stage = controller
                          .appState.value.availablePipelineStages[index];
                      return Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(
                                () => ConfirmationPage(
                                  image: Enums.getIconStage(
                                      stage.uid.split('-')[0]),
                                  text: '${stage.name}?',
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Enums.getIconStage(stage.uid.split('-')[0]),
                                    color: theme.colorScheme.primary,
                                    width: 19,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    stage.name,
                                    style: theme.textTheme.headline3,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: theme.bottomSheetTheme.modalBackgroundColor!
                                .withOpacity(0.1),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
