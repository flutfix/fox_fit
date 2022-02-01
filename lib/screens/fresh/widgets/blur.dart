// ignore_for_file: use_key_in_widget_constructors

import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryEffect extends StatelessWidget {
  final double opacity;
  final double blurry;
  final Color shade;

  // ignore: prefer_const_constructors_in_immutables
  BlurryEffect(this.opacity, this.blurry, this.shade);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurry, sigmaY: blurry),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: shade.withOpacity(opacity),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
