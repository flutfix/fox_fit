import 'package:flutter/material.dart';

class AssignedPage extends StatefulWidget {
  const AssignedPage({Key? key}) : super(key: key);

  @override
  _AssignedPageState createState() => _AssignedPageState();
}

class _AssignedPageState extends State<AssignedPage> {
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
