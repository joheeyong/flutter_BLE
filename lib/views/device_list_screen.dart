import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';
import 'package:flutterble/providers/ble_provider.dart';
import 'package:flutterble/providers/device_detail_provider.dart';
import 'package:flutterble/views/device_detail_screen.dart';
import 'package:provider/provider.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bleProvider = Provider.of<BleProvider>(context, listen: false);
      await Future.delayed(const Duration(milliseconds: 800));
      bleProvider.fetchDevices();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _rssiColor(int rssi) {
    if (rssi >= -60) return Colors.green;
    if (rssi >= -70) return Colors.blue;
    if (rssi >= -80) return Colors.orange;
    return Colors.red;
  }

  String _rssiStatus(int rssi) {
    if (rssi >= -60) return '매우 안정적';
    if (rssi >= -70) return '안정적';
    if (rssi >= -80) return '불안정';
    return '매우 불안정';
  }

  Future<void> _attemptConnection(BleProvider bleProvider) async {
    final device = bleProvider.selectedDevice;
    if (device == null) return;

    try {
      await bleProvider.connectWithRetry(
        device,
        onRetry: (attempt) {
          if (mounted) {
            setState(() {}); // retryCount 업데이트 표시
          }
        },
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => DeviceDetailProvider(),
            child: DeviceDetailScreen(device: device),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('연결 실패: ${device.name}')),
      );
    } finally {
      if (mounted) {
        setState(() {}); // isRetrying 상태 갱신
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BleProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('BLE 디바이스 스캐너'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // 연결된 디바이스가 있으면 상단에 표시
            if (bleProvider.selectedDevice != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '현재 연결 선택된 디바이스',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '이름: ${bleProvider.selectedDevice!.name}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'ID: ${bleProvider.selectedDevice!.deviceId}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bleProvider.devices.length,
                itemBuilder: (context, index) {
                  final BleDevice device = bleProvider.devices[index];
                  final bool isSelected =
                      bleProvider.selectedDevice == device;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: isSelected
                          ? Border.all(color: Colors.blueAccent, width: 2)
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: Icon(Icons.bluetooth,
                          color: _rssiColor(device.rssi), size: 32),
                      title: Text(
                        device.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'RSSI: ${device.rssi} dBm',
                            style: TextStyle(
                              color: _rssiColor(device.rssi),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${_rssiStatus(device.rssi)})',
                            style: TextStyle(
                              color: _rssiColor(device.rssi),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                          color: Colors.blueAccent)
                          : null,
                      onTap: () {
                        if (bleProvider.selectedDevice == device) {
                          bleProvider.clearSelection();
                        } else {
                          bleProvider.selectDevice(device);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: bleProvider.selectedDevice != null &&
                        !bleProvider.isRetrying
                        ? () => _attemptConnection(bleProvider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.link),
                    label: const Text(
                      '연결 시도',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (bleProvider.isRetrying && bleProvider.retryCount > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '연결 재시도 중... (${bleProvider.retryCount}/3)',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
