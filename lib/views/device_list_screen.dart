import 'package:flutter/material.dart';
import 'package:flutterble/models/ble_device.dart';
import 'package:flutterble/providers/ble_provider.dart';
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
      await Future.delayed(const Duration(milliseconds: 800)); // 로딩 시뮬레이션
      bleProvider.fetchDevices();
      setState(() {
        _isLoading = false;
      });
      _controller.forward(); // 리스트 페이드 인
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _rssiColor(int rssi) {
    if (rssi >= -60) return Colors.green; // 매우 안정적
    if (rssi >= -70) return Colors.blue; // 안정적
    if (rssi >= -80) return Colors.orange; // 불안정
    return Colors.red; // 매우 불안정
  }

  String _rssiStatus(int rssi) {
    if (rssi >= -60) return '매우 안정적';
    if (rssi >= -70) return '안정적';
    if (rssi >= -80) return '불안정';
    return '매우 불안정';
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
                          ? Border.all(
                          color: Colors.blueAccent, width: 2)
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
                          // 같은 디바이스를 클릭하면 선택 해제
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
              child: ElevatedButton.icon(
                onPressed: bleProvider.selectedDevice != null
                    ? () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                    content: Text(
                        '${bleProvider.selectedDevice!.name} 연결 시도 중...'),
                  ));
                }
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
            ),
          ],
        ),
      ),
    );
  }
}
