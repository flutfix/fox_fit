import 'package:flutter/material.dart';
import 'package:fox_fit/generated/l10n.dart';

class Selector extends StatefulWidget {
  final int controller;
  final EdgeInsetsGeometry? margin;
  final Function(int)? onTap;

  const Selector({
    Key? key,
    required this.controller,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  // late int _controller;

  @override
  void initState() {
    super.initState();
    // _controller = 0;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: widget.margin,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: theme.selectedRowColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _button(
                width: width,
                theme: theme,
                context: context,
                text: S.of(context).history,
                index: 0,
                isActive: widget.controller == 0 ? true : false,
              ),
              _button(
                width: width,
                theme: theme,
                context: context,
                text: S.of(context).services,
                index: 1,
                isActive: widget.controller == 1 ? true : false,
              ),
              _button(
                width: width,
                theme: theme,
                context: context,
                text: S.of(context).customers,
                index: 2,
                isActive: widget.controller == 2 ? true : false,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _divider(
                theme: theme,
                opacity: widget.controller == 2 ? 1 : 0,
              ),
              _divider(
                theme: theme,
                opacity: widget.controller == 0 ? 1 : 0,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _button({
    required double width,
    required ThemeData theme,
    required BuildContext context,
    required String text,
    required int index,
    required bool isActive,
  }) {
    // Вычет отступов
    width = (width - 68) / 3;

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(index);
        }
      },
      child: AnimatedContainer(
        width: isActive ? width : width - 8,
        padding: EdgeInsets.symmetric(vertical: isActive ? 8 : 4),
        margin: EdgeInsets.all(isActive ? 0 : 4),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? theme.backgroundColor : theme.selectedRowColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: theme.textTheme.headline2!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider({
    required ThemeData theme,
    required double opacity,
  }) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 1,
        height: 23,
        color: theme.dividerColor.withOpacity(0.2),
      ),
    );
  }
}
