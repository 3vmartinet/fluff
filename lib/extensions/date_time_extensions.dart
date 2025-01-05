library fluff;

import 'package:intl/intl.dart';

final DateFormat _timestampDateFormat = DateFormat("yyyyMMdd");
final DateFormat _humanDateFormat = DateFormat("yMMMMd");
final DateFormat _timestampTimeFormat = DateFormat("Hms");

extension DateTImeExtensions on DateTime {
  String get ymd => _timestampDateFormat.format(this);
  String get yMMMMd => _humanDateFormat.format(this);
  int get ymdInt => int.parse(ymd);

  String get hms => _timestampTimeFormat.format(this);
  int get hmsInt => int.parse(hms);
}
