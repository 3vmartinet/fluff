library fluff;

import 'package:intl/intl.dart';

final DateFormat _timestampDateFormat = DateFormat("yyyyMMdd");
final DateFormat _timestampTimeFormat = DateFormat("Hms");

extension DateTImeExtensions on DateTime {
  String ymdString() => _timestampDateFormat.format(this);
  int ymdInt() => int.parse(ymdString());

  String hmsString() => _timestampTimeFormat.format(this);
  int hmsInt() => int.parse(hmsString());
}
