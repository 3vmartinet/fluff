import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeZoneRepo {
  static final TimeZoneRepo _instance = TimeZoneRepo._init();
  factory TimeZoneRepo() => _instance;

  TimeZoneRepo._init() {
    tz.initializeTimeZones();
  }

  TZDateTime get now => TZDateTime.now(tz.local);

  Future<void> setDefaultLocalTimeZone() async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }
}
