import 'package:flutter/material.dart';

class Still extends StatefulWidget {
  const Still({ Key? key }) : super(key: key);

  @override
  _StillState createState() => _StillState();
}

class _StillState extends State<Still> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ещё',
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}