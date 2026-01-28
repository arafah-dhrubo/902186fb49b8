import '../../domain/entities/device_vitals.dart';

class DeviceVitalsModel extends DeviceVitals {
  const DeviceVitalsModel({
    required super.thermalState,
    required super.batteryLevel,
    required super.memoryUsagePercentage,
  });

  factory DeviceVitalsModel.fromEntity(DeviceVitals entity) {
    return DeviceVitalsModel(
      thermalState: entity.thermalState,
      batteryLevel: entity.batteryLevel,
      memoryUsagePercentage: entity.memoryUsagePercentage,
    );
  }
}
