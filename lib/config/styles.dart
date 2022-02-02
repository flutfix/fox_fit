import 'package:flutter/material.dart';

abstract class Styles {
  /*------------------COLORS-------------------*/
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFFAFAF8);
  static const Color greyLight = Color(0xFF3C3C3C);
  static const Color greyLight2 = Color(0xFFE8E8E8);
  static const Color blue = Color(0xFF2692DA);
  static const Color primaryText = Color(0xFF333E63);
  static const Color secondaryText = Color(0xFF3A4060);
  static const Color primaryLightText = Color(0xFF59597C);
  static const Color orange = Color(0xFFFE5900);
  static const Color disableIcon = Color(0xFF6E7288);
  static const Color borderColor = Color(0xFFF1F1F1);

  ///Default font family
  static const String mainFontFamily = 'Open Sans';

  ///Theme
  static ThemeData get getLightTheme {
    return ThemeData(
      fontFamily: Styles.mainFontFamily,
      brightness: Brightness.light,
      backgroundColor: Styles.white,
      colorScheme: const ColorScheme.light(
        ///[Orange] Color
        primary: Styles.orange,

        ///[Light Blue] Color
        secondary: Styles.blue,

        ///[White] Color
        surface: Styles.white,
      ),

      /// Стиль для Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Styles.grey,

        /// Для разделителя
        modalBackgroundColor: Styles.greyLight,
      ),

      /// Text Color
      hintColor: Styles.primaryText,

      /// [Grey] Color
      canvasColor: Styles.grey,

      /// Inactive BottomBar Icon Color
      hoverColor: Styles.disableIcon,

      /// Border Color
      splashColor: Styles.borderColor,

      /// Разделитель
      dividerColor: Styles.secondaryText,

      /// Text Theme
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Styles.primaryText,
        ),
        headline2: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Styles.primaryText,
        ),
        headline3: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Styles.secondaryText,
        ),
        headline4: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Styles.primaryLightText,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Styles.primaryText,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Styles.primaryText,
        ),
        caption: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: Styles.primaryText,
        ),
        button: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Styles.white,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
