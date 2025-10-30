import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';

const int _megaBytes = 1024 * 1024;

class DeviceInfoRepo {
  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

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
    return (
      SysInfo.getAvailablePhysicalMemory() ~/ _megaBytes,
      SysInfo.getTotalPhysicalMemory() ~/ _megaBytes
    );
  }

  Future<int> get processorCoreCount async {
    return SysInfo.cores.length;
  }
}
