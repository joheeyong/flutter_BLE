import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterble/providers/ble_provider.dart';
import 'package:flutterble/views/device_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('로딩 인디케이터가 먼저 보이고, 이후 디바이스 리스트 10개가 표시된다', (tester) async {
    // 테스트 환경 화면 크기 크게 조정 (예: 1000 x 2000)
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    tester.view.devicePixelRatio = 3.0;

    final provider = BleProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: DeviceListScreen()),
      ),
    );

    // 처음에는 로딩 인디케이터가 보여야 함
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 비동기 fetchDevices 완료 대기
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 로딩 인디케이터는 사라지고, ListTile이 10개 보여야 함
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListTile), findsNWidgets(10));

    // 테스트 종료 후 화면 크기 리셋
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.view.resetDevicePixelRatio();
    });
  });

}
