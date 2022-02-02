import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    required this.width,
    required this.icon,
    required this.textController,
    required this.hintText,
    this.textStyle,
    this.textInputAction = TextInputAction.done,
    this.backgroundColor,
    this.scrollPaddingBottom = 0,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.textFormatters,
  }) : super(key: key);

  final double width;
  final String icon;
  final String hintText;
  final TextEditingController textController;
  final TextStyle? textStyle;
  final TextInputAction textInputAction;
  final Color? backgroundColor;
  final double scrollPaddingBottom;
  final TextInputType textInputType;
  final bool obscureText;
  final List<TextInputFormatter>? textFormatters;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;
    TextStyle textStyle = widget.textStyle ??
        theme.textTheme.headline1!.copyWith(fontWeight: FontWeight.w400);
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: backgroundColor,
          border: Border.all(width: 1, color: theme.dividerColor)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 19),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.icon,
              width: 18,
            ),
            const SizedBox(width: 11),
            SizedBox(
              width: 200,
              child: TextField(
                obscuringCharacter: '*',
                inputFormatters: widget.textFormatters,
                obscureText: widget.obscureText,
                scrollPadding:
                    EdgeInsets.only(bottom: widget.scrollPaddingBottom),
                controller: widget.textController,
                textInputAction: widget.textInputAction,
                keyboardType: widget.textInputType,
                style: textStyle,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
