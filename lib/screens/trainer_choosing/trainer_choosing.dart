import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/trainer.dart';
import 'package:fox_fit/screens/confirmation/confirmation.dart';
import 'package:fox_fit/screens/trainer_choosing/widgets/search.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class TrainerChoosingPage extends StatefulWidget {
  const TrainerChoosingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TrainerChoosingPage> createState() => _TrainerChoosingPageState();
}

class _TrainerChoosingPageState extends State<TrainerChoosingPage> {
  late bool loading;
  late GeneralController controller;

  @override
  void initState() {
    controller = Get.find<GeneralController>();
    getTrainers();
    super.initState();
  }

  Future<void> getTrainers() async {
    setState(() {
      loading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: controller.getTrainers,
    );

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).triner_choosing,
        isBackArrow: true,
        onBack: () {
          Get.back();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Search(
              controller: TextEditingController(),
              onSearch: (search) {
                setState(() {
                  controller.sortTrainers(search: search.trim());
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      child: Column(
                        children: [
                          ...List.generate(
                            controller.appState.value.sortedAvailableTrainers !=
                                    null
                                ? controller.appState.value
                                    .sortedAvailableTrainers!.length
                                : controller
                                    .appState.value.availableTrainers.length,
                            (index) {
                              Trainer trainer;
                              if (controller
                                      .appState.value.sortedAvailableTrainers !=
                                  null) {
                                trainer = controller.appState.value
                                    .sortedAvailableTrainers![index];
                              } else {
                                trainer = controller
                                    .appState.value.availableTrainers[index];
                              }
                              return GestureDetector(
                                onTap: () {
                                  controller.appState.update((model) {
                                    model?.currentTrainer = trainer;
                                  });
                                  Get.to(
                                    () => ConfirmationPage(
                                      stagePipelineType:
                                          StagePipelineType.coordinator,
                                      textButtonDone: S.of(context).transmit,
                                      richText: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '${S.of(context).transmit}\n',
                                              style: theme.textTheme.headline5,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${controller.appState.value.currentCustomer!.fullName}\n',
                                              style: theme.textTheme.headline6!
                                                  .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${S.of(context).to_coach.toLowerCase()} ',
                                              style: theme.textTheme.headline5,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${controller.appState.value.currentTrainer!.name}?',
                                              style: theme.textTheme.headline6!
                                                  .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(color: theme.dividerColor),
                                    const SizedBox(height: 15),
                                    Text(
                                      trainer.name,
                                      style: theme.textTheme.subtitle2!
                                          .copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
