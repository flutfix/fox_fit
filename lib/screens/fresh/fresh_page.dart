import 'package:flutter/material.dart';
import 'package:fox_fit/models/client_model.dart';
import 'package:fox_fit/screens/fresh/widgets/client_container.dart';

class FreshPage extends StatefulWidget {
  const FreshPage({Key? key}) : super(key: key);

  @override
  _FreshPageState createState() => _FreshPageState();
}

class _FreshPageState extends State<FreshPage> {
  late List<ClientModel> fakeModel;

  @override
  void initState() {
    fakeModel = [
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      // ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      // ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      // ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      // ClientModel(fullName: 'Сантанова Юлия Игоревна'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 182,
            child: Column(
              children: [
                const SizedBox(height: 25),
                ...List.generate(
                  fakeModel.length,
                  (index) {
                    return ClientContainer(
                      client: fakeModel[index],
                      isActive: index == 0 ? false : true,
                    );
                  },
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
