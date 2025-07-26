import 'package:flutter_test/flutter_test.dart';
import 'package:flutterble/repository/mock_ble_repository.dart';

void main() {
  group('MockBleRepository', () {
    late MockBleRepository repository;

    setUp(() {
      repository = MockBleRepository();
    });

    test('getDevices 호출 시 10개의 BLE 디바이스가 반환된다', () {
      final devices = repository.getDevices();
      expect(devices.length, 10);
    });

    test('getDevices가 불변 리스트를 반환한다', () {
      final devices = repository.getDevices();

      expect(() => devices.add(devices.first), throwsA(isA<UnsupportedError>()));
    });
  });
}
