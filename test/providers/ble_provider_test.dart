import 'package:flutter_test/flutter_test.dart';
import 'package:flutterble/providers/ble_provider.dart';

void main() {
  group('BleProvider', () {
    late BleProvider provider;

    setUp(() {
      provider = BleProvider();
    });

    test('fetchDevices 호출 시 10개의 BLE 디바이스가 로드된다', () {
      provider.fetchDevices();
      expect(provider.devices.length, 10);
    });

    test('selectDevice 호출 시 선택된 디바이스가 설정된다', () {
      provider.fetchDevices();
      final device = provider.devices.first;

      provider.selectDevice(device);
      expect(provider.selectedDevice, equals(device));
    });

    test('clearSelection 호출 시 선택된 디바이스가 해제된다', () {
      provider.fetchDevices();
      final device = provider.devices.first;

      provider.selectDevice(device);
      provider.clearSelection();

      expect(provider.selectedDevice, isNull);
    });
  });
}
