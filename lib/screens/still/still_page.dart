import 'package:flutter/material.dart';

class StillPage extends StatefulWidget {
  const StillPage({ Key? key }) : super(key: key);

  @override
  _StillPageState createState() => _StillPageState();
}

class _StillPageState extends State<StillPage> {
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