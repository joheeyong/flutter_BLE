import 'package:flutter/material.dart';
import 'package:flutterble/providers/ble_provider.dart';
import 'package:flutterble/views/device_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter BLE 시뮬레이터',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const DeviceListScreen(),
      ),
    );
  }
}
