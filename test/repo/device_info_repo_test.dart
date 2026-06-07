import 'package:fluff/repo/device_info_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  group('DeviceInfoRepo - isVersionSatisfied', () {
    setUp(() {
      PackageInfo.setMockInitialValues(
        appName: 'Fluff',
        packageName: 'com.example.fluff',
        version: '1.2.3',
        buildNumber: '1',
        buildSignature: '',
      );
    });

    test('should return true if major is greater', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(2, 0, 0);
      expect(result, isTrue);
    });

    test('should return false if major is lower', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(0, 9, 9);
      expect(result, isFalse);
    });

    test('should return true if major is equal and minor is greater', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(1, 3, 0);
      expect(result, isTrue);
    });

    test('should return false if major is equal and minor is lower', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(1, 1, 9);
      expect(result, isFalse);
    });

    test('should return true if major and minor are equal and patch is greater', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(1, 2, 4);
      expect(result, isTrue);
    });

    test('should return true if major, minor, and patch are equal', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(1, 2, 3);
      expect(result, isTrue);
    });

    test('should return false if major and minor are equal and patch is lower', () async {
      final repo = DeviceInfoRepo();
      final result = await repo.isVersionSatisfied(1, 2, 2);
      expect(result, isFalse);
    });
  });
}
