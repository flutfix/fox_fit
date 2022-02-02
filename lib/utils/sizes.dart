import 'package:flutter/cupertino.dart';

class Sizes {
  /// Рассчитывает высоту колонки для того, чтобы появилась анимация прокручивания
  static double getHeightColumnForScroll({
    required BuildContext context,
    bool withAppBar = true,
    bool withBottomBar = true,
  }) {
    if (withAppBar && withBottomBar) {
      return MediaQuery.of(context).size.height - 192;
    } else if (withAppBar && withBottomBar == false) {
      return MediaQuery.of(context).size.height - 116;
    } else if (withAppBar == false && withBottomBar) {
      return MediaQuery.of(context).size.height - 66;
    } else {
      return MediaQuery.of(context).size.height;
    }
  }
}
