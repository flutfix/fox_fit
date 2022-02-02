import 'package:flutter/material.dart';
import 'package:fox_fit/models/client_model.dart';
import 'package:fox_fit/utils/sizes.dart';
import 'package:fox_fit/widgets/default_container.dart';

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
    ThemeData theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: Sizes.getHeightColumnForScroll(context: context),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Expanded(
                child: ListView.separated(
                  itemCount: fakeModel.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 6);
                  },
                  itemBuilder: (context, index) {
                    return DefaultContainer(
                      isBlured: index == 0 ? false : true,
                      child: Text(
                        fakeModel[index].fullName,
                        style: theme.textTheme.bodyText1,
                      ),
                    );
                  },
                ),
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
