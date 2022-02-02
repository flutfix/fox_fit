import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/fresh/widgets/blur.dart';

class ClientContainer extends StatefulWidget {
  const ClientContainer({
    Key? key,
    required this.client,
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  final CustomerModel client;
  final Function()? onTap;
  final bool isActive;
  @override
  _ClientContainerState createState() => _ClientContainerState();
}

class _ClientContainerState extends State<ClientContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    if (widget.isActive) {
      return SizedBox(
        width: width,
        height: 60,
        child: Stack(
          children: [
            getClientContainer(width, theme),
            BlurryEffect(0.1, 3, Colors.white)
          ],
        ),
      );
    } else {
      return getClientContainer(width, theme);
    }
  }

  Widget getClientContainer(double width, ThemeData theme) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        child: Container(
          width: width,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          margin: const EdgeInsets.only(bottom: 6.0),
          decoration: BoxDecoration(
              color: !widget.isActive
                  ? theme.canvasColor
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            widget.client.fullName,
            style: theme.textTheme.bodyText1,
          ),
        ),
      );
}
