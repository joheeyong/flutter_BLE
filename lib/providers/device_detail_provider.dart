import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class DeviceDetailProvider extends ChangeNotifier {
  bool _isConnecting = false;
  bool _isConnected = false;

  final List<String> _sentMessages = [];
  final List<String> _receivedMessages = [];

  Timer? _mockResponseTimer;
  final Random _random = Random();

  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;

  List<String> get sentMessages => List.unmodifiable(_sentMessages);
  List<String> get receivedMessages => List.unmodifiable(_receivedMessages);

  Future<void> connect() async {
    _isConnecting = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isConnecting = false;
    _isConnected = true;
    notifyListeners();

    _startMockResponseTimer();
  }

  void disconnect() {
    _isConnected = false;
    _sentMessages.clear();
    _receivedMessages.clear();
    _mockResponseTimer?.cancel();
    notifyListeners();
  }

  void sendData(String data) {
    if (!_isConnected) return;

    _sentMessages.add(data);
    notifyListeners();
  }

  void _startMockResponseTimer() {
    _mockResponseTimer?.cancel();

    _mockResponseTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_isConnected) {
        _mockResponseTimer?.cancel();
        return;
      }

      final response = '응답: Random Data ${_random.nextInt(100)}';
      _receivedMessages.add(response);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _mockResponseTimer?.cancel();
    super.dispose();
  }
}
