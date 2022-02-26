import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';

class SelectServicePage extends StatefulWidget {
  const SelectServicePage({Key? key}) : super(key: key);

  @override
  _SelectServicePageState createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  late bool _isLoading;
  late GeneralController _generalController;
  late ScheduleController _scheduleController;

  @override
  void initState() {
    super.initState();
    _scheduleController = Get.find<ScheduleController>();
    _generalController = Get.find<GeneralController>();
    _isLoading = true;
    getCustomerFitnessServices();
  }

  Future<void> getCustomerFitnessServices() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: () {
        String serviceType = Enums.getTrainingTypeString(
          trainingType: _scheduleController.state.value.type,
        );

        return _scheduleController.getCustomerFitnessServices(
          userUid: _generalController.getUid(role: UserRole.trainer),
          customerUid: _scheduleController.state.value.clients![0].model.uid,
          duration: _scheduleController.state.value.duration.toString(),
          serviceType: serviceType,
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
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).choice_service,
        isBackArrow: true,
        isNotification: false,
        onBack: () {
          Get.back();
        },
      ),
      body: (!_isLoading)
          ? _scheduleController.state.value.services.isNotEmpty
              ? SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  physics: const BouncingScrollPhysics(),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _scheduleController.state.value.services.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      return DefaultContainer(
                        padding:
                            const EdgeInsets.fromLTRB(28, 17.45, 19, 22.55),
                        child: GestureDetector(
                          onTap: () {
                            _scheduleController.state.update((model) {
                              model?.service = _scheduleController
                                  .state.value.services[index];
                            });
                            Get.back();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _scheduleController
                                    .state.value.services[index].name,
                                style: theme.textTheme.subtitle2!
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : DefaultContainer(
                  padding: const EdgeInsets.fromLTRB(28, 17.45, 19, 22.55),
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    'Услуг не найдено',
                    style: theme.textTheme.subtitle2!.copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
