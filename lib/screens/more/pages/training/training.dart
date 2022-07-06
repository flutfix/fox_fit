import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fox_fit/config/styles.dart';
import 'package:get/get.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:swipe/swipe.dart';
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
        child: SimpleGestureDetector(
          onHorizontalSwipe: _onHorizontalSwipe,
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
      ),
    );
  }

  void _onHorizontalSwipe(SwipeDirection direction) {
    Get.back();
  }
}
