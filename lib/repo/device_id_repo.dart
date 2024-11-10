library fluff;

import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdRepo {
  static final DeviceIdRepo _instance = DeviceIdRepo._init();
  factory DeviceIdRepo() => _instance;

  DeviceIdRepo._init();

  Future<String?>? getUserId() async {
    if (Platform.isAndroid) {
      const plugin = AndroidId();
      return await plugin.getId();
    } else if (Platform.isIOS) {
      final plugin = DeviceInfoPlugin();
      final info = await plugin.iosInfo;

      return info.identifierForVendor;
    }
    return null;
  }
}
