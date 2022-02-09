import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:get/get.dart';

class Snackbar {
  static void getSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 2),
      backgroundColor: Styles.grey,
      colorText: Styles.greyLight,
      boxShadows: [
        BoxShadow(
          color: Styles.black.withOpacity(0.10),
          offset: const Offset(0, 4),
          blurRadius: 15,
        )
      ],
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
