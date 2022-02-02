import 'package:flutter/material.dart';

class PerfomedPage extends StatefulWidget {
  const PerfomedPage({Key? key}) : super(key: key);

  @override
  _PerfomedPageState createState() => _PerfomedPageState();
}

class _PerfomedPageState extends State<PerfomedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Проведено',
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}
