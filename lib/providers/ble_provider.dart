import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';
import 'package:flutterble/repository/mock_ble_repository.dart';

class BleProvider extends ChangeNotifier {
  final MockBleRepository _repository = MockBleRepository();

  List<BleDevice> _devices = [];
  BleDevice? _selectedDevice;

  bool _isRetrying = false;
  int _retryCount = 0;

  List<BleDevice> get devices => _devices;
  BleDevice? get selectedDevice => _selectedDevice;
  bool get isRetrying => _isRetrying;
  int get retryCount => _retryCount;

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

  // 선택 해제
  void clearSelection() {
    _selectedDevice = null;
    notifyListeners();
  }

  // 디바이스 연결 (최대 3회 재시도)
  Future<void> connectWithRetry(
      BleDevice device, {
        void Function(int attempt)? onRetry,
      }) async {
    const maxRetries = 3;
    _isRetrying = true;
    _retryCount = 0;
    notifyListeners();

    Exception? lastError;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      _retryCount = attempt;
      notifyListeners();
      onRetry?.call(attempt);

      try {
        await _repository.connect(device);
        _isRetrying = false;
        notifyListeners();
        return; // 성공하면 바로 리턴
      } catch (e) {
        lastError = Exception(e.toString());
        await Future.delayed(const Duration(seconds: 1)); // 재시도 대기
      }
    }

    _isRetrying = false;
    notifyListeners();
    throw lastError ?? Exception('Unknown connection error');
  }

  Future<void> disconnect() async {
    await _repository.disconnect();
    _selectedDevice = null;
    notifyListeners();
  }

  Future<String> readData() async {
    return _repository.readData();
  }

  Future<void> writeData(String data) async {
    await _repository.writeData(data);
  }
}
