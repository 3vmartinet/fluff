import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

extension TzDateTimeExtensions on TZDateTime {
  TZDateTime withTimeOfDay(TimeOfDay timeOfDay) =>
      TZDateTime(local, year, month, day, timeOfDay.hour, timeOfDay.minute);
}
