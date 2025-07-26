import 'package:flutter_test/flutter_test.dart';
import 'package:flutterble/providers/device_detail_provider.dart';

void main() {
  group('DeviceDetailProvider 단위 테스트', () {
    late DeviceDetailProvider provider;

    setUp(() {
      provider = DeviceDetailProvider();
    });

    test('초기 상태 테스트', () {
      expect(provider.isConnecting, false);
      expect(provider.isConnected, false);
      expect(provider.receivedData, '');
    });

    test('connect() 호출 시 상태 변화 테스트', () async {
      final future = provider.connect();

      // connect 시작 후 isConnecting은 true
      expect(provider.isConnecting, true);

      // 2초 대기 후 연결 완료 상태 확인
      await future;
      expect(provider.isConnecting, false);
      expect(provider.isConnected, true);
    });

    test('disconnect() 호출 시 상태 초기화 테스트', () async {
      await provider.connect();
      expect(provider.isConnected, true);

      provider.disconnect();

      expect(provider.isConnected, false);
      expect(provider.receivedData, '');
    });

    test('sendData() 호출 시 데이터 수신 반영 테스트', () async {
      await provider.connect();
      expect(provider.isConnected, true);

      provider.sendData('테스트 데이터');

      // sendData 내부 Timer(1초) 기다리기
      await Future.delayed(const Duration(seconds: 1, milliseconds: 100));

      expect(provider.receivedData, '응답 수신: 테스트 데이터');
    });

    test('isConnected가 false일 때 sendData() 호출 무시 테스트', () async {
      expect(provider.isConnected, false);

      provider.sendData('무시되는 데이터');

      // 1초 기다려도 receivedData는 변화 없어야 함
      await Future.delayed(const Duration(seconds: 1, milliseconds: 100));

      expect(provider.receivedData, '');
    });
  });
}
