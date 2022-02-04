import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    this.width,
    this.icon,
    this.iconPng,
    this.iconPngWidth,
    required this.textController,
    required this.hintText,
    this.textStyle,
    this.textInputAction = TextInputAction.done,
    this.backgroundColor,
    this.scrollPaddingBottom = 0,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.textFormatters,
    this.borderRadius,
    this.padding,
    this.lines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.cursorColor,
    this.hintStyle,
    this.onChanged,
  }) : super(key: key);

  final double? width;
  final String? icon;
  final String? iconPng;
  final double? iconPngWidth;
  final String hintText;
  final TextEditingController textController;
  final TextStyle? textStyle;
  final TextInputAction textInputAction;
  final Color? backgroundColor;
  final double scrollPaddingBottom;
  final TextInputType textInputType;
  final bool obscureText;
  final List<TextInputFormatter>? textFormatters;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final int lines;
  final TextCapitalization textCapitalization;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;

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
          borderRadius: widget.borderRadius ?? BorderRadius.circular(100),
          color: backgroundColor,
          border: Border.all(width: 1, color: theme.splashColor)),
      child: Padding(
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: 22.0, vertical: 19),
        child: Row(
          children: [
            if (widget.icon != null)
              SvgPicture.asset(
                widget.icon!,
                width: 18,
              ),
            if (widget.iconPng != null)
              Image.asset(
                widget.iconPng!,
                width: widget.iconPngWidth,
              ),
            if (widget.icon != null || widget.iconPng != null)
              const SizedBox(width: 11),
            Expanded(
              child: TextField(
                onChanged: widget.onChanged,
                cursorColor: widget.cursorColor,
                textCapitalization: widget.textCapitalization,
                minLines: widget.lines,
                maxLines: widget.lines,
                obscuringCharacter: '*',
                inputFormatters: widget.textFormatters,
                obscureText: widget.obscureText,
                scrollPadding:
                    EdgeInsets.only(bottom: widget.scrollPaddingBottom),
                controller: widget.textController,
                textInputAction: widget.textInputAction,
                keyboardType: widget.textInputType,
                style: textStyle,
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  hintStyle: widget.hintStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
