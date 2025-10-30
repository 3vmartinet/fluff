import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_device_info_plus/flutter_device_info_plus.dart';

class DeviceInfoRepo {
  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();
  final FlutterDeviceInfoPlus _deviceInfo = const FlutterDeviceInfoPlus();

  DeviceInfoRepo();

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

  Future<(int availableMb, int totalMb)> get physicalMemoryMb async {
    final info = (await _deviceInfo.getDeviceInfo()).memoryInfo;

    return (
      info.availablePhysicalMemoryMB ~/ 1,
      info.totalPhysicalMemoryMB ~/ 1
    );
  }

  Future<(int coreCount, int maxFreq)> get processorInfo async {
    final info = (await _deviceInfo.getDeviceInfo()).processorInfo;
    return (info.coreCount, info.maxFrequency);
  }
}
