import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';
import 'package:flutterble/repository/mock_ble_repository.dart';

class BleProvider extends ChangeNotifier {

  BleProvider({MockBleRepository? repository})
      : _repository = repository ?? MockBleRepository();
  final MockBleRepository _repository;

  List<BleDevice> _devices = [];
  BleDevice? _selectedDevice;

  List<BleDevice> get devices => List.unmodifiable(_devices);
  BleDevice? get selectedDevice => _selectedDevice;

  // Mock 데이터를 불러와 디바이스 목록을 초기화
  void fetchDevices() {
    _devices = _repository.getDevices();
    notifyListeners();
  }

  // 디바이스 선택
  void selectDevice(BleDevice device) {
    _selectedDevice = device;
    notifyListeners();
  }

  /// 선택 해제
  void clearSelection() {
    _selectedDevice = null;
    notifyListeners();
  }
}
