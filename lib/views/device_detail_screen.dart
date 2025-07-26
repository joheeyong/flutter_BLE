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
            // AppBar 액션은 그대로 유지
            actions: [
              if (provider.isConnected)
                IconButton(
                  icon: const Icon(Icons.link_off),
                  onPressed: provider.disconnect,
                  tooltip: '연결 해제',
                ),
            ],
          ),
          // 연결 끊기 버튼을 하단에 고정시키기 위해 bottomNavigationBar 사용
          bottomNavigationBar: provider.isConnected
              ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.disconnect();
                  Navigator.pop(context); // 화면 닫기
                },
                icon: const Icon(Icons.link_off, size: 28),
                label: const Text(
                  '연결 해제',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                  MediaQuery.of(context).size.height - kToolbarHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('디바이스 ID: ${widget.device.deviceId}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('RSSI: ${widget.device.rssi} dBm',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 24),

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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

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

                        const Text(
                          '송신 로그',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: provider.sentMessages.length,
                            itemBuilder: (context, index) {
                              return Text(provider.sentMessages[index]);
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          '수신 로그',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: provider.receivedMessages.length,
                            itemBuilder: (context, index) {
                              return Text(provider.receivedMessages[index]);
                            },
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
