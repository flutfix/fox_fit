import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/fresh/widgets/client_container.dart';
import 'package:get/get.dart';

class FreshPage extends StatefulWidget {
  const FreshPage({Key? key}) : super(key: key);

  @override
  _FreshPageState createState() => _FreshPageState();
}

class _FreshPageState extends State<FreshPage> {
  late List<CustomerModel> fakeModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GeneralController controller = Get.put(GeneralController());

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 25),
              ...List.generate(
                controller.appState.value.customers.length,
                (index) {
                  return ClientContainer(
                    client: controller.appState.value.customers[index],
                    isActive:
                        controller.appState.value.customers[index].isVisible,
                  );
                },
              ),
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
