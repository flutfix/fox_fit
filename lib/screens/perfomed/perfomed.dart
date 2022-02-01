import 'package:flutter/material.dart';

class Perfomed extends StatefulWidget {
  const Perfomed({Key? key}) : super(key: key);

  @override
  _PerfomedState createState() => _PerfomedState();
}

class _PerfomedState extends State<Perfomed> {
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
