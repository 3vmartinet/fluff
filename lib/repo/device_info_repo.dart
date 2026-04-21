import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  final String version;
  final String packageName;
  final String buildNumber;

  const AppInfo({
    required this.version,
    required this.packageName,
    required this.buildNumber,
  });
}

class DeviceInfoRepo {
  late final DeviceInfoPlugin _plugin;

  DeviceInfoRepo() {
    _plugin = DeviceInfoPlugin();
  }

  Future<AppInfo> get appInfo async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      version: info.version,
      packageName: info.packageName,
      buildNumber: info.buildNumber,
    );
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
