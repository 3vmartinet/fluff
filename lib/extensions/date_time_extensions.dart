library fluff;

import 'package:intl/intl.dart';

final DateFormat _timestampDateFormat = DateFormat("yyyyMMdd");
final DateFormat _humanDateFormat = DateFormat("yMMMMd");
final DateFormat _humanMonthDateFormatLong = DateFormat("MMMM");
final DateFormat _humanMonthDateFormatShort = DateFormat("MMM");
final DateFormat _humanDateFormatNoYear = DateFormat("MMMMd");
final DateFormat _timestampTimeFormat = DateFormat("Hms");

extension DateTImeExtensions on DateTime {
  String get ymd => _timestampDateFormat.format(this);
  String yMMMMd({bool includeYear = true}) => includeYear
      ? _humanDateFormat.format(this)
      : _humanDateFormatNoYear.format(this);
  String get monthCamelCaseLong => _humanMonthDateFormatLong.format(this);
  String get monthCamelCaseShort => _humanMonthDateFormatShort.format(this);
  int get ymdInt => int.parse(ymd);

  String get hms => _timestampTimeFormat.format(this);
  int get hmsInt => int.parse(hms);
}
