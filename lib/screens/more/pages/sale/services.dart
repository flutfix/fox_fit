import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/sales_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/animated_container.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late bool _isLoading;
  late SalesController _salesController;
  late GeneralController _generalController;
  @override
  void initState() {
    _isLoading = false;
    _salesController = Get.find<SalesController>();
    _generalController = Get.find<GeneralController>();
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
          return _salesController.getServices(
              userUid: _generalController.getUid(
            role: UserRole.trainer,
          ));
        });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () {
        _onBack();
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: CustomAppBar(
          title: S.of(context).choose_service,
          isBackArrow: true,
          onBack: () {
            _onBack();
          },
          isNotification: false,
        ),
        body: !_isLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      /// Услуги
                      Obx(
                        () => _buildServicesList(
                          theme,
                          items: _salesController.state.value.services,
                          header: S.of(context).services,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Пакеты
                      Obx(
                        () => _buildServicesList(
                          theme,
                          items: _salesController.state.value.packageOfServices,
                          header: S.of(context).packages,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildServicesList(
    ThemeData theme, {
    required List<ServicesModel> items,
    required String header,
  }) {
    if (items.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: theme.textTheme.headline2!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          Column(
            children: [
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: CustomAnimatedContainer(
                      text: items[index].name,
                      onTap: () {
                        _onBack();
                        _salesController.state.update((model) {
                          model?.currentService = items[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  void _onBack() {
    Get.back();
    _salesController.state.update((model) {
      model?.services = [];
      model?.packageOfServices = [];
    });
  }
}
