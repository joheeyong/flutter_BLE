import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';

enum ConnectionStateMock { disconnected, connecting, connected }

class MockBleRepository {
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

  ConnectionStateMock _connectionState = ConnectionStateMock.disconnected;
  BleDevice? _connectedDevice;

  int retryCount = 0; // 현재 재시도 횟수
  bool isRetrying = false; // 재시도 중 상태

  ConnectionStateMock get connectionState => _connectionState;

  BleDevice? get connectedDevice => _connectedDevice;

  /// BLE 연결 시뮬레이션 (RSSI 기반 성공 확률 + 재시도 로직)
  Future<void> connect(BleDevice device) async {
    _connectionState = ConnectionStateMock.connecting;

    await Future.delayed(const Duration(seconds: 1));

    final rssi = device.rssi;
    final successRate = calculateSuccessRate(rssi);

    final randomValue = Random().nextInt(100);
    if (randomValue < successRate) {
      _connectedDevice = device;
      _connectionState = ConnectionStateMock.connected;
    } else {
      _connectedDevice = null;
      _connectionState = ConnectionStateMock.disconnected;
      throw Exception('Failed to connect due to weak signal');
    }
  }

  /// 연결 해제
  Future<void> disconnect() async {
    _connectionState = ConnectionStateMock.disconnected;
    _connectedDevice = null;
  }

  /// 데이터 읽기 (연결된 상태만 가능)
  Future<String> readData() async {
    if (_connectionState != ConnectionStateMock.connected) {
      throw Exception('Device not connected');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Mock data from ${_connectedDevice?.name}';
  }

  /// 데이터 쓰기 (연결된 상태만 가능)
  Future<void> writeData(String data) async {
    if (_connectionState != ConnectionStateMock.connected) {
      throw Exception('Device not connected');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Sent data to ${_connectedDevice?.name}: $data');
  }

  int calculateSuccessRate(int rssi) {
    if (rssi >= -60) {
      return 90;
    } else if (rssi <= -90) {
      return 5;
    } else {
      // -60 ~ -90 구간에 대해 선형 보간
      // successRate = 90 - ((rssi + 60) * (85 / 30))
      final double rate = 90 - ((-60 - rssi) * (85 / 30));
      return rate.round();
    }
  }
}
