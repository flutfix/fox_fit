import 'package:flutter/material.dart';
import 'package:fox_fit/screens/customers/widgets/blur.dart';

class DefaultContainer extends StatefulWidget {
  const DefaultContainer({
    Key? key,
    this.isVisible = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    required this.child,
  }) : super(key: key);

  final bool isVisible;
  final Function()? onTap;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  _DefaultContainerState createState() => _DefaultContainerState();
}

class _DefaultContainerState extends State<DefaultContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    if (widget.isVisible) {
      return getClientContainer(width, theme);
    } else {
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
    }
  }

  Widget getClientContainer(double width, ThemeData theme) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: Container(
        width: width,
        padding: widget.padding,
        decoration: BoxDecoration(
            color: widget.isVisible
                ? theme.canvasColor
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10)),
        child: widget.child,
      ),
    );
  }
}
