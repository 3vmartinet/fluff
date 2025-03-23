library fluff;

import 'dart:ui';

import 'package:intl/intl.dart';

extension DateTImeExtensions on DateTime {
  static String? _localeCode;

  DateFormat get _timestampDateFormat => DateFormat("yyyyMMdd", _localeCode);
  DateFormat get _humanDateFormat => DateFormat("yMMMMd", _localeCode);
  DateFormat get _humanMonthDateFormatLong => DateFormat("MMMM", _localeCode);
  DateFormat get _humanMonthDateFormatShort => DateFormat("MMM", _localeCode);
  DateFormat get _humanDateFormatNoYear => DateFormat("MMMMd", _localeCode);
  DateFormat get _timestampTimeFormat => DateFormat("Hms", _localeCode);
  DateFormat get _timestampTimeFormatNoSeconds => DateFormat("Hm", _localeCode);

  static void setLocale(Locale locale) => _localeCode = locale.languageCode;

  String get ymd => _timestampDateFormat.format(this);
  String yMMMMd({bool includeYear = true}) => includeYear
      ? _humanDateFormat.format(this)
      : _humanDateFormatNoYear.format(this);
  String get monthCamelCaseLong => _humanMonthDateFormatLong.format(this);
  String get monthCamelCaseShort => _humanMonthDateFormatShort.format(this);
  int get ymdInt => int.parse(ymd);

  String get hms => _timestampTimeFormat.format(this);
  String get hm => _timestampTimeFormatNoSeconds.format(this);
  int get hmsInt => int.parse(hms);
}
