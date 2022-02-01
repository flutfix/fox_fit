import 'package:flutter/material.dart';

class ItemBottomBar {
  ItemBottomBar({
    required this.icon,
    required this.name,
    required this.activeColor,
    required this.inactiveColor,
  });

  final String icon;
  final String name;
  final Color activeColor;
  final Color inactiveColor;
}
