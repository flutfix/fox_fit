import 'package:flutter/material.dart';

class Stable extends StatefulWidget {
  const Stable({ Key? key }) : super(key: key);

  @override
  _StableState createState() => _StableState();
}

class _StableState extends State<Stable> {
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