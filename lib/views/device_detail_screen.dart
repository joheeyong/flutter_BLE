import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';
import 'package:flutterble/providers/device_detail_provider.dart';
import 'package:provider/provider.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({super.key, required this.device});
  final BleDevice device;

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final TextEditingController _dataController = TextEditingController();

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceDetailProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.device.name} 상세 정보'),
            backgroundColor: Colors.blueAccent,
            centerTitle: true,
            actions: [
              if (provider.isConnected)
                IconButton(
                  icon: const Icon(Icons.link_off),
                  onPressed: provider.disconnect,
                  tooltip: '연결 해제',
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('디바이스 ID: ${widget.device.deviceId}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('RSSI: ${widget.device.rssi} dBm',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),

                // 연결 상태 표시
                if (provider.isConnecting)
                  const Center(child: CircularProgressIndicator()),
                if (!provider.isConnected && !provider.isConnecting)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: provider.connect,
                      icon: const Icon(Icons.link),
                      label: const Text('연결상태 확인'),
                    ),
                  ),
                if (provider.isConnected) ...[
                  const Text(
                    '디바이스와 연결됨',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // 데이터 전송 UI
                  TextField(
                    controller: _dataController,
                    decoration: const InputDecoration(
                      labelText: '보낼 데이터',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final text = _dataController.text.trim();
                      if (text.isNotEmpty) {
                        provider.sendData(text);
                        _dataController.clear();
                      }
                    },
                    child: const Text('데이터 전송'),
                  ),
                  const SizedBox(height: 24),

                  // 수신 데이터 표시
                  if (provider.receivedData.isNotEmpty)
                    Text(
                      provider.receivedData,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
