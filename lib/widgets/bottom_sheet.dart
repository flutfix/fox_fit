import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),

          /// Разделитель
          Container(
            height: 5,
            width: 135,
            decoration: BoxDecoration(
              color:
                  theme.bottomSheetTheme.modalBackgroundColor!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 41),

          /// Основной контент
          child,
        ],
      ),
    );
  }
}
