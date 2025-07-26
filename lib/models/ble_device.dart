import 'package:equatable/equatable.dart';

class BleDevice extends Equatable {

  const BleDevice({
    required this.deviceId,
    required this.name,
    required this.rssi,
  });

  factory BleDevice.fromJson(Map<String, dynamic> json) {
    return BleDevice(
      deviceId: json['deviceId'] as String,
      name: json['name'] as String,
      rssi: json['rssi'] as int,
    );
  }
  final String deviceId;
  final String name;
  final int rssi;

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': name,
      'rssi': rssi,
    };
  }

  @override
  List<Object?> get props => [deviceId, name, rssi];
}
