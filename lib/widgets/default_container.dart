import 'package:flutter/material.dart';
import 'package:fox_fit/screens/customers/widgets/blur.dart';

class DefaultContainer extends StatefulWidget {
  const DefaultContainer({
    Key? key,
    this.isVisible = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    this.margin,
    required this.child,
    this.isHighlight,
    this.highlightColor,
    this.width,
    this.height,
  }) : super(key: key);

  final bool isVisible;
  final Function()? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final bool? isHighlight;
  final Color? highlightColor;
  final double? width;
  final double? height;

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
        height: 80,
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
        width: widget.width ?? width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: getContainerColor(theme),
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.child,
      ),
    );
  }

  Color getContainerColor(ThemeData theme) {
    Color color = theme.canvasColor;
    if (widget.isVisible) {
      if (widget.isHighlight != null) {
        if (widget.isHighlight!) {
          color = widget.highlightColor ??
              theme.colorScheme.primary.withOpacity(0.07);
        }
      }
    } else {
      color = theme.colorScheme.surface;
    }
    return color;
  }
}
