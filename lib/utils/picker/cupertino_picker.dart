import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fox_fit/utils/picker/scroll_behavior.dart';

class CustomCupertinoPicker extends StatefulWidget {
  const CustomCupertinoPicker({
    Key? key,
    required this.width,
    required this.height,
    required this.items,
    required this.buttonsStyle,
    required this.itemExtent,
    required this.onChanged,
    this.selectionOverlay,
    this.currentIndex = 0,
  }) : super(key: key);

  final double width;
  final double height;
  final List<dynamic> items;
  final TextStyle buttonsStyle;
  final double itemExtent;
  final Widget? selectionOverlay;
  final int currentIndex;
  final Function(int)? onChanged;
  @override
  _CustomCupertinoPickerState createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
  late int currentIndex;
  @override
  void initState() {
    currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomBehavior(),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CupertinoPicker.builder(
          scrollController:
              FixedExtentScrollController(initialItem: widget.currentIndex),
          backgroundColor: Colors.transparent,
          selectionOverlay: widget.selectionOverlay ??

              ///Default Selection Overlay
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
          itemExtent: widget.itemExtent,
          onSelectedItemChanged: (int index) {
            currentIndex = index;
            if (widget.onChanged != null) {
              widget.onChanged!(currentIndex);
            }
          },
          useMagnifier: true,
          childCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: widget.height,
              alignment: Alignment.center,
              child: Text(
                widget.items[index].toString(),
                style: widget.buttonsStyle,
                textAlign: TextAlign.start,
              ),
            );
          },
        ),
      ),
    );
  }
}
