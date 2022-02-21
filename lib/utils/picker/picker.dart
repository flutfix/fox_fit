import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fox_fit/utils/behavior.dart';
import 'package:fox_fit/widgets/bottom_sheet.dart';

class Picker {
  static Future<DateTime?> custom({
    required BuildContext context,
    required ThemeData theme,
    required List<dynamic> values,
    Function(int value)? onChanged,
    Function(int value)? onConfirm,
    Function()? onCancel,
  }) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        int currentIndex = 0;
        return CustomBottomSheet(
          isDivider: false,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (onCancel != null) {
                        onCancel();
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Отмена',
                      style: theme.textTheme.headline2,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (onConfirm != null) {
                        onConfirm(values[currentIndex]);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Готово',
                      style: theme.textTheme.headline2!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ScrollConfiguration(
                behavior: CustomBehavior(),
                child: SizedBox(
                  width: 100,
                  child: CupertinoPicker.builder(
                    backgroundColor: Colors.transparent,
                    itemExtent: 30,
                    onSelectedItemChanged: (int index) {
                      currentIndex = index;
                      if (onChanged != null) {
                        onChanged(values[index]);
                      }
                    },
                    useMagnifier: true,
                    childCount: values.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          values[index].toString(),
                          style: theme.textTheme.bodyText2,
                          textAlign: TextAlign.start,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
