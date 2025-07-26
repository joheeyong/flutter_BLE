import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';

class DeviceDetailScreen extends StatelessWidget {

  const DeviceDetailScreen({super.key, required this.device});
  final BleDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${device.name} 상세 정보'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '디바이스 ID:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Text(device.deviceId,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 24),
            Text(
              '신호 세기 (RSSI):',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Text('${device.rssi} dBm',
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 24),
            // 기타 상세 정보나 통신 관련 UI 추가 가능
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('뒤로가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
