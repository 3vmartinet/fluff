library fluff;

import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoRepo {
  static final DeviceInfoRepo _instance = DeviceInfoRepo._init();
  factory DeviceInfoRepo() => _instance;

  late final DeviceInfoPlugin _plugin;

  DeviceInfoRepo._init() {
    _plugin = DeviceInfoPlugin();
  }

  Future<String?> get id async {
    if (Platform.isAndroid) {
      const plugin = AndroidId();
      return await plugin.getId();
    } else if (Platform.isIOS) {
      return (await _plugin.iosInfo).identifierForVendor;
    }
    return null;
  }

  Future<String?> get name async {
    if (Platform.isAndroid) {
      return (await _plugin.androidInfo).model;
    } else if (Platform.isIOS) {
      return (await _plugin.iosInfo).name;
    }
    return null;
  }
}
