import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeZoneRepo {
  TimeZoneRepo() {
    tz.initializeTimeZones();
  }

  Location get location => tz.local;

  TZDateTime get now => TZDateTime.now(location);

  Future<void> setDefaultLocalTimeZone() async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
  }
}
