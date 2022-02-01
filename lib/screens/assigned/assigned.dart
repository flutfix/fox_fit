import 'package:flutter/material.dart';

class Assigned extends StatefulWidget {
  const Assigned({Key? key}) : super(key: key);

  @override
  _AssignedState createState() => _AssignedState();
}

class _AssignedState extends State<Assigned> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Назначено',
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}
