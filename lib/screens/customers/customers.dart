import 'package:flutter/material.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:get/get.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GeneralController controller = Get.put(GeneralController());
    ThemeData theme = Theme.of(context);
    int currentIndex = controller.appState.value.currentIndex;
    String stageId = controller.appState.value.bottomBarItems[currentIndex].uid;
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _refresh,
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 25),
              if (controller.appState.value.sortedCustomers[stageId] != null)
                ...List.generate(
                    controller.appState.value.sortedCustomers[stageId]!.length,
                    (index) {
                  var customer = controller
                      .appState.value.sortedCustomers[stageId]![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        DefaultContainer(
                          isVisible: customer.isVisible,
                          child: Text(
                            customer.fullName,
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                        if (index !=
                            controller.appState.value.customers.length - 1)
                          const SizedBox(height: 6),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
