import 'package:flutter/material.dart';
import 'package:fox_fit/models/client_model.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FreshPage extends StatefulWidget {
  const FreshPage({Key? key}) : super(key: key);

  @override
  _FreshPageState createState() => _FreshPageState();
}

class _FreshPageState extends State<FreshPage> {
  late List<ClientModel> fakeModel;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    fakeModel = [
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
      ClientModel(fullName: 'Сантанова Юлия Игоревна'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _refresh,
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 25),
            ...List.generate(
              fakeModel.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    DefaultContainer(
                      isBlured: index == 0 ? false : true,
                      child: Text(
                        fakeModel[index].fullName,
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                    if (index != fakeModel.length - 1)
                      const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
