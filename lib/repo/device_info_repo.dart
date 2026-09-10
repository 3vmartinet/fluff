import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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
    // No stable per-install id in a browser; the caller treats null as
    // "unknown" already.
    if (kIsWeb) return null;

    if (Platform.isAndroid) {
      const plugin = AndroidId();
      return await plugin.getId();
    } else if (Platform.isIOS) {
      return (await _plugin.iosInfo).identifierForVendor;
    }
    return null;
  }

  Future<String?> get name async {
    if (kIsWeb) {
      final info = await _plugin.webBrowserInfo;
      return info.browserName.name;
    }

    if (Platform.isAndroid) {
      return (await _plugin.androidInfo).model;
    } else if (Platform.isIOS) {
      return (await _plugin.iosInfo).name;
    }
    return null;
  }

  Future<bool> isVersionSatisfied(int major, int minor, int patch) async {
    final info = await appInfo;
    final cleanVersion = info.version.split('-').first.split('+').first;
    final parts = cleanVersion.split('.');
    final appMajor = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? 0) : 0;
    final appMinor = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    final appPatch = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;

    if (major != appMajor) {
      return major > appMajor;
    }
    if (minor != appMinor) {
      return minor > appMinor;
    }
    return patch >= appPatch;
  }
}
