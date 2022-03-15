import 'package:flutter/material.dart';
import 'package:fox_fit/utils/picker/cupertino_picker.dart';
import 'package:fox_fit/utils/picker/show_picker.dart';

class Picker {
  ///--------------------------[Time Picker]--------------------------///
  static Future<dynamic> time({
    required BuildContext context,
    Function(dynamic value)? onChanged,
    Function(dynamic value)? onConfirm,
    Function()? onCancel,

    /// [Functionality]
    /// Must be provided the value what u need to be focused in minutes range
    /// From 00 to 09 hours/minutes u must to provide 0-9 variables, without first 0
    int currentHour = 0,
    int currentMinute = 0,

    /// Interval between range of minutes
    int minutesInterval = 1,

    /// [Style]
    double width = 100,
    double height = 100,
    Color? backgroundColor,
    Color? doneButtonColor,
    EdgeInsetsGeometry? buttonsPadding,
    Widget? selectionOverlay,
    double itemExtent = 32,
    BorderRadiusGeometry? borderRadius,
    Color? dividerColor,
    String dividerSymbol = ':',

    /// TextStyle for values in picker
    TextStyle valueStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    /// TextStyle for buttons [Cancel] [Done]
    TextStyle buttonsStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  }) async {
    List<String> hours = _getHours;
    List<String> minutes = _getMinutes(minutesInterval);

    /// Search for the index of the transmitted minute value for further focus
    int currentMinutesIndex = _getCurrentValueIndex(
      current: currentMinute,
      values: minutes,
      valuesType: ValuesType.minutes,
    );
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        int hoursIndex = currentHour;
        int minutesIndex = currentMinutesIndex;

        return ShowPicker(
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          buttonsPadding: buttonsPadding,
          buttonsStyle: buttonsStyle,
          onCancel: () {
            if (onCancel != null) {
              onCancel();
            }
            Navigator.pop(context);
          },
          onConfirm: () {
            if (onConfirm != null) {
              var now = DateTime.now();
              DateTime chosenTime = DateTime(
                now.year,
                now.month,
                now.day,
                int.parse(hours[hoursIndex]),
                int.parse(minutes[minutesIndex]),
              );
              onConfirm(
                chosenTime,
              );
            }
            Navigator.pop(context);
          },
          doneButtonColor: doneButtonColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// [Hours]
                CustomCupertinoPicker(
                  width: width,
                  height: height,
                  items: hours,
                  buttonsStyle: buttonsStyle,
                  itemExtent: itemExtent,
                  selectionOverlay: selectionOverlay,
                  currentIndex: hoursIndex,
                  onChanged: (index) {
                    hoursIndex = index;
                    if (onChanged != null) {
                      onChanged(hours[index]);
                    }
                  },
                ),

                Text(
                  dividerSymbol,
                  style: valueStyle.copyWith(
                    color: dividerColor ?? Colors.black,
                  ),
                ),

                /// [Minutes]
                CustomCupertinoPicker(
                  width: width,
                  height: height,
                  items: minutes,
                  buttonsStyle: buttonsStyle,
                  itemExtent: itemExtent,
                  selectionOverlay: selectionOverlay,
                  currentIndex: minutesIndex,
                  onChanged: (index) {
                    minutesIndex = index;
                    if (onChanged != null) {
                      onChanged(minutes[index]);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static List<String> get _getHours {
    List<String> hours = [];
    for (var i = 0; i < 24; i++) {
      if (i < 10) {
        hours.add('0$i');
      } else {
        hours.add('$i');
      }
    }
    return hours;
  }

  static List<String> _getMinutes(int interval) {
    List<String> minutes = [];
    for (var i = 0; i < 60; i += interval) {
      if (i < 10) {
        minutes.add('0$i');
      } else {
        minutes.add('$i');
      }
    }
    return minutes;
  }

  ///--------------------------[Custom Picker]--------------------------///
  static Future<dynamic> custom({
    required BuildContext context,
    required List<dynamic> values,
    Function(dynamic value)? onChanged,
    Function(dynamic value)? onConfirm,
    Function()? onCancel,
    dynamic currentValue = 0,

    /// Picker Style
    double width = 100,
    double height = 100,
    Color? backgroundColor,
    Color? doneButtonColor,
    EdgeInsetsGeometry? buttonsPadding,
    Widget? selectionOverlay,
    double itemExtent = 32,
    BorderRadiusGeometry? borderRadius,

    /// TextStyle for values in picker
    TextStyle valueStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    /// TextStyle for buttons [Cancel] [Done]
    TextStyle buttonsStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  }) async {
    int currentIndex = _getCurrentValueIndex(
      current: currentValue,
      values: values,
    );
    // log('$currentIndex');

    /// Custom Picker Sheet
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return ShowPicker(
            onCancel: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.pop(context);
            },
            onConfirm: () {
              if (onConfirm != null) {
                onConfirm(values[currentIndex]);
              }
              Navigator.pop(context);
            },
            borderRadius: borderRadius,
            buttonsPadding: buttonsPadding,
            buttonsStyle: buttonsStyle,
            doneButtonColor: doneButtonColor,
            backgroundColor: backgroundColor,

            /// Custom Values
            child: CustomCupertinoPicker(
              width: width,
              height: height,
              items: values,
              buttonsStyle: buttonsStyle,
              currentIndex: currentIndex,
              itemExtent: itemExtent,
              onChanged: (index) {
                currentIndex = index;
                if (onChanged != null) {
                  onChanged(values[index]);
                }
              },
            ));
      },
    );
  }

  /// Get current minute index by value
  static int _getCurrentValueIndex({
    required dynamic current,
    required List<dynamic> values,
    ValuesType valuesType = ValuesType.custom,
  }) {
    switch (valuesType) {
      case ValuesType.custom:
        var currentIndex = values.indexWhere(
          (element) => element == current,
        );
        return currentIndex == -1 ? 0 : currentIndex;
      case ValuesType.minutes:
        String str = '';
        if (current < 10) {
          str = '0$current';
        } else {
          str = current.toString();
        }
        var currentIndex = values.indexWhere(
          (element) => element == str,
        );
        return currentIndex == -1 ? 0 : currentIndex;
    }
  }
}

enum ValuesType {
  custom,
  minutes,
}
