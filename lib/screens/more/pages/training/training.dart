// ignore_for_file: prefer_collection_literals

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:get/get.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.white,
      child: SafeArea(
        child: Stack(
          children: [
            SimpleGestureDetector(
              onHorizontalSwipe: (SwipeDirection direction) {
                if (direction == SwipeDirection.right) {
                  Get.back();
                }
              },
              child: WebView(
                initialUrl: 'https://foxfit.app/trener',
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.back();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      Images.backArrow,
                      width: 16,
                    ),
                    const SizedBox(
                      width: 36,
                      height: 36,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
