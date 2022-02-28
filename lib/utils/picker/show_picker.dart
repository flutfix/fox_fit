import 'package:flutter/material.dart';
import 'package:fox_fit/utils/picker/bottom_sheet.dart';

class ShowPicker extends StatefulWidget {
  const ShowPicker({
    Key? key,
    required this.backgroundColor,
    required this.borderRadius,
    required this.buttonsPadding,
    required this.buttonsStyle,
    required this.onCancel,
    required this.onConfirm,
    required this.doneButtonColor,
    required this.child,
  }) : super(key: key);
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? buttonsPadding;
  final TextStyle? buttonsStyle;
  final Function()? onCancel;
  final Function()? onConfirm;
  final Color? doneButtonColor;
  final Widget? child;
  @override
  _ShowPickerState createState() => _ShowPickerState();
}

class _ShowPickerState extends State<ShowPicker> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      borderRadius: widget.borderRadius ??
          const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
      padding:
          widget.buttonsPadding ?? const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// [Cancel]
              _textButton(
                text: 'Отмена',
                buttonsStyle: widget.buttonsStyle,
                onTap: widget.onCancel,
              ),

              /// [Done]
              _textButton(
                text: 'Готово',
                buttonsStyle: widget.buttonsStyle!
                    .copyWith(color: widget.doneButtonColor ?? Colors.red),
                onTap: widget.onConfirm,
              ),
            ],
          ),
          const SizedBox(height: 40),

          /// Custom Values
          widget.child ?? const SizedBox()
        ],
      ),
    );
  }

  static Widget _textButton({
    required String text,
    Function()? onTap,
    TextStyle? buttonsStyle,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Text(
        text,
        style: buttonsStyle,
      ),
    );
  }
}
