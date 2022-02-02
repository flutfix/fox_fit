import 'package:flutter/material.dart';

abstract class Styles {
  /*------------------COLORS-------------------*/
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFFAFAF8);
  static const Color blue = Color(0xFF2692DA);
  static const Color darkBlue = Color(0xFF333E63);
  static const Color orange = Color(0xFFFE5900);
  static const Color disableIcon = Color(0xFF6E7288);
  static const Color borderColor = Color(0xFFF1F1F1);

  /// Стандартный шрифт
  static const String mainFontFamily = 'Open Sans';

  /// Светлая тема
  static ThemeData get getLightTheme {
    return ThemeData(
      fontFamily: Styles.mainFontFamily,
      brightness: Brightness.light,
      backgroundColor: Styles.white,
      colorScheme: const ColorScheme.light(
        /// [Оранжевый] Цвет
        primary: Styles.orange,

        /// [Голубой] Цвет
        secondary: Styles.blue,

        /// [Белый] Цвет
        surface: Styles.white,
      ),

      /// Цвет текста
      hintColor: Styles.darkBlue,

      /// [Серый] Цвет
      canvasColor: Styles.grey,

      /// Неактивный цвет иконки BottomBar
      hoverColor: Styles.disableIcon,

      /// Цвет разделяющей линии
      dividerColor: Styles.borderColor,

      /// Шрифты
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Styles.darkBlue,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Styles.darkBlue,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Styles.darkBlue,
        ),
        caption: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: Styles.darkBlue,
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
