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
      expect(provider.sentMessages, isEmpty);
      expect(provider.receivedMessages, isEmpty);
    });

    test('connect() 호출 시 상태 변화 테스트', () async {
      final future = provider.connect();

      expect(provider.isConnecting, true);

      await future;

      expect(provider.isConnecting, false);
      expect(provider.isConnected, true);
    });

    test('disconnect() 호출 시 상태 초기화 테스트', () async {
      await provider.connect();

      expect(provider.isConnected, true);

      provider.disconnect();

      expect(provider.isConnected, false);
      expect(provider.sentMessages, isEmpty);
      expect(provider.receivedMessages, isEmpty);
    });

    test('sendData() 호출 시 송신 로그에 메시지 추가 테스트', () async {
      await provider.connect();

      provider.sendData('테스트 메시지');

      expect(provider.sentMessages, contains('테스트 메시지'));
    });

    test('isConnected가 false일 때 sendData() 호출 무시 테스트', () {
      expect(provider.isConnected, false);

      provider.sendData('무시되는 메시지');

      expect(provider.sentMessages, isEmpty);
    });

    test('주기적 mock 응답이 수신 로그에 추가되는지 테스트', () async {
      await provider.connect();

      // 최대 4초 대기해 3초 주기 mock 응답이 1번 이상 들어오는지 확인
      await Future.delayed(const Duration(seconds: 4));

      expect(provider.receivedMessages.isNotEmpty, true);
    });
  });
}
