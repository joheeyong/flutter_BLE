import 'package:flutterble/models/ble_device.dart';

class MockBleRepository {
  // 10개의 Mock BLE 디바이스 리스트
  final List<BleDevice> _devices = const [
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174000', name: 'BLE_DEVICE_001', rssi: -65),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174001', name: 'BLE_DEVICE_002', rssi: -70),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174002', name: 'BLE_DEVICE_003', rssi: -80),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174003', name: 'BLE_DEVICE_004', rssi: -75),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174004', name: 'BLE_DEVICE_005', rssi: -60),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174005', name: 'BLE_DEVICE_006', rssi: -68),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174006', name: 'BLE_DEVICE_007', rssi: -82),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174007', name: 'BLE_DEVICE_008', rssi: -77),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174008', name: 'BLE_DEVICE_009', rssi: -69),
    BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174009', name: 'BLE_DEVICE_010', rssi: -73),
  ];

  // 모든 BLE 디바이스 리스트 반환
  List<BleDevice> getDevices() => List.unmodifiable(_devices);
}
