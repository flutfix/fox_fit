import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    this.width,
    this.height,
    required this.text,
    required this.backgroundColor,
    required this.textStyle,
    this.onTap,
    this.textPadding = 17,
    this.borderRadius = 100,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String text;
  final Function()? onTap;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double textPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: textPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
