import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterble/models/ble_device.dart';
import 'package:flutterble/providers/device_detail_provider.dart';
import 'package:flutterble/views/device_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('DeviceDetailScreen 테스트', () {
    late BleDevice mockDevice;

    setUp(() {
      mockDevice = const  BleDevice(deviceId: '123e4567-e89b-12d3-a456-426614174000', name: 'BLE_DEVICE_001', rssi: -65);
    });

    testWidgets('디바이스 상세 정보가 정상적으로 표시된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DeviceDetailProvider(),
            child: DeviceDetailScreen(device: mockDevice),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final titleText = '${mockDevice.name} 상세 정보';

      expect(find.text(titleText), findsOneWidget);
      expect(find.textContaining('디바이스 ID:'), findsOneWidget);
      expect(find.textContaining(mockDevice.deviceId), findsOneWidget);
      expect(find.textContaining('${mockDevice.rssi} dBm'), findsOneWidget);
    });
  });
}
