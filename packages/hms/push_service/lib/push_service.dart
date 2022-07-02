library push_service;

import 'dart:developer';

import 'package:huawei_push/huawei_push.dart';
import 'package:push_service_interface/push_service_interface.dart';

part 'src/hms.dart';

abstract class PushServiceProvider {
  static IService getPushService() => PushService();
}
