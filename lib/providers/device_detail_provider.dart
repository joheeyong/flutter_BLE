import 'dart:async';
import 'package:flutter/foundation.dart';

class DeviceDetailProvider extends ChangeNotifier {
  bool _isConnecting = false;
  bool _isConnected = false;
  String _receivedData = '';

  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  String get receivedData => _receivedData;

  /// 디바이스 연결 시뮬레이션 (2초 후 성공)
  Future<void> connect() async {
    _isConnecting = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isConnecting = false;
    _isConnected = true;
    notifyListeners();
  }

  /// 연결 해제
  void disconnect() {
    _isConnected = false;
    _receivedData = '';
    notifyListeners();
  }

  /// 데이터 전송 (1초 후 가상 응답)
  void sendData(String data) {
    if (!_isConnected) return;

    Timer(const Duration(seconds: 1), () {
      _receivedData = '응답 수신: $data';
      notifyListeners();
    });
  }
}
