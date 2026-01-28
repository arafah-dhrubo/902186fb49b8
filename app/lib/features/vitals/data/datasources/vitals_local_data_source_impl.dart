import 'package:flutter/services.dart';
import 'package:app/features/vitals/data/datasources/vitals_local_data_source.dart';
import 'package:app/features/vitals/data/models/device_vitals_model.dart';

class VitalsLocalDataSourceImpl implements VitalsLocalDataSource {
  static const MethodChannel _channel = MethodChannel(
    'com.example.vital/vitals',
  );

  @override
  Future<DeviceVitalsModel> getVitals() async {
    try {
      final int thermalState = await _channel.invokeMethod('getThermalState');
      final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
      final double memoryUsage = await _channel.invokeMethod('getMemoryUsage');

      return DeviceVitalsModel(
        thermalState: thermalState,
        batteryLevel: batteryLevel,
        memoryUsagePercentage: memoryUsage,
      );
    } on PlatformException catch (e) {
      throw Exception("Native Platform Error: ${e.message}");
    }
  }

  @override
  Future<String> getDeviceId() async {
    try {
      final String? deviceId = await _channel.invokeMethod<String>(
        'getDeviceId',
      );
      return deviceId ?? 'unknown_device';
    } catch (e) {
      return 'unknown_device';
    }
  }
}
