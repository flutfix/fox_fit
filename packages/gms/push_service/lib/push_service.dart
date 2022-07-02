library push_service;

import 'dart:developer';
import 'dart:io';

import 'package:push_service_interface/push_service_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'src/gms.dart';

abstract class PushServiceProvider {
  static IService getPushService() => PushService();
}
