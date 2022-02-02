import 'package:flutter/material.dart';

class StablePage extends StatefulWidget {
  const StablePage({Key? key}) : super(key: key);

  @override
  _StablePageState createState() => _StablePageState();
}

class _StablePageState extends State<StablePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Постоянные',
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}
