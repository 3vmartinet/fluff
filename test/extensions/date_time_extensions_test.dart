import 'package:fluff/extensions/date_time_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('DateTimeExtensions', () {
    final testDate = DateTime(2023, 12, 25, 14, 30, 45);

    setUpAll(() async {
      // Initialize all locales we're going to test
      await Future.wait([
        initializeDateFormatting('en'),
        initializeDateFormatting('de'),
        initializeDateFormatting('fr'),
      ]);
    });

    setUp(() {
      DateTImeExtensions.setLocale(const Locale('en'));
    });

    test('ymd returns correct format', () {
      expect(testDate.ymd, equals('20231225'));
    });

    test('yMMMMd with year returns correct format', () {
      expect(testDate.yMMMMd(), equals('December 25, 2023'));
    });

    test('yMMMMd without year returns correct format', () {
      expect(testDate.yMMMMd(includeYear: false), equals('December 25'));
    });

    test('yMMMd with year returns correct format', () {
      expect(testDate.yMMMd(), equals('Dec 25, 2023'));
    });

    test('yMMMd without year returns correct format', () {
      expect(testDate.yMMMd(includeYear: false), equals('Dec 25'));
    });

    test('monthCamelCaseLong returns correct format', () {
      expect(testDate.monthCamelCaseLong, equals('December'));
    });

    test('monthCamelCaseShort returns correct format', () {
      expect(testDate.monthCamelCaseShort, equals('Dec'));
    });

    test('ymdInt returns correct integer', () {
      expect(testDate.ymdInt, equals(20231225));
    });

    test('hms returns correct format', () {
      expect(testDate.hms, equals('14:30:45'));
    });

    test('hm returns correct format', () {
      expect(testDate.hm, equals('14:30'));
    });

    test('hmsInt returns correct integer', () {
      expect(testDate.hmsInt, equals(143045));
    });

    group('locale changes', () {
      test('formats adapt to German locale', () {
        DateTImeExtensions.setLocale(const Locale('de'));
        expect(testDate.yMMMMd(), equals('25. Dezember 2023'));
        expect(testDate.monthCamelCaseLong, equals('Dezember'));
      });

      test('formats adapt to French locale', () {
        DateTImeExtensions.setLocale(const Locale('fr'));
        expect(testDate.yMMMMd(), equals('25 décembre 2023'));
        expect(testDate.monthCamelCaseLong, equals('décembre'));
      });
    });
  });
}
