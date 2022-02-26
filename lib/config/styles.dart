import 'package:flutter/material.dart';

abstract class Styles {
  /*------------------COLORS-------------------*/
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFFAFAF8);
  static const Color greyLight = Color(0xFF3C3C3C);
  static const Color greyLight2 = Color(0xFFE8E8E8);
  static const Color greyLight3 = Color(0xFFE0E0E0);
  static const Color greyLight4 = Color(0xFFE7EBEF);
  static const Color greyLight5 = Color(0xFFBDBDBD);
  static const Color greyLight6 = Color(0xFFF2F2F2);
  static const Color greyLight7 = Color(0xFF828282);
  static const Color blue = Color(0xFF2692DA);
  static const Color primaryText = Color(0xFF333E63);
  static const Color secondaryText = Color(0xFF3A4060);
  static const Color primaryLightText = Color(0xFF59597C);
  static const Color orange = Color(0xFFFE5900);
  static const Color disableIcon = Color(0xFF6E7288);
  static const Color borderColor = Color(0xFFF1F1F1);
  static const Color borderBlue = Color(0xFF2694DA);
  static const Color darkBlue = Color(0xFF1D7AB9);
  static const Color darkGrey = Color(0xFFD7D7D7);
  static const Color darkOrange = Color(0xFFE55000);
  static const Color green = Colors.green;
  static const Color yellow = Colors.yellow;
  static const Color red = Colors.red;

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

      /// Стиль для Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Styles.grey,

        /// Для разделителя
        modalBackgroundColor: Styles.greyLight,
      ),

      /// Цвет текста
      hintColor: Styles.primaryText,

      /// [Серый] Цвет
      canvasColor: Styles.grey,

      /// Неактивный цвет иконки BottomBar
      hoverColor: Styles.disableIcon,

      /// Border Color
      splashColor: Styles.borderColor,

      /// Цвет разделяющей линии
      dividerColor: Styles.secondaryText,

      /// Голубой бордер
      focusColor: Styles.borderBlue,

      ///[Воронка продаж] цввета линий
      ///Серый
      cardColor: Styles.darkGrey,

      ///Оранжевый
      highlightColor: Styles.darkOrange,

      ///Синий
      disabledColor: Styles.darkBlue,

      /// [Уведомления] цвет непрочитанных
      indicatorColor: Styles.green.withOpacity(0.2),

      /// Цвет неактивного колокольчика уведомлений
      iconTheme: const IconThemeData(color: Styles.greyLight3),

      buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.light(
          primary: Styles.greyLight4,
          secondary: Styles.primaryText,
        ),
      ),

      /// Для выбора даты переноса
      primaryTextTheme: const TextTheme(
        headline2: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Styles.orange,
        ),
      ),

      /// Шрифты
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
        headline5: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Styles.secondaryText,
        ),
        headline6: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Styles.borderBlue,
        ),
        subtitle1: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w700,
          color: Styles.secondaryText,
        ),
        subtitle2: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: Styles.secondaryText,
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
          letterSpacing: 0.02,
        ),
        overline: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Styles.greyLight5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
