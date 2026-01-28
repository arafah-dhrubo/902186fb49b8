import '../../domain/entities/vital_log.dart';

class VitalLogModel extends VitalLog {
  const VitalLogModel({
    super.id,
    required super.deviceId,
    required super.timestamp,
    required super.thermalValue,
    required super.batteryLevel,
    required super.memoryUsage,
  });

  factory VitalLogModel.fromJson(Map<String, dynamic> json) {
    return VitalLogModel(
      id: json['id']?.toString(),
      deviceId: json['device_id'],
      timestamp: DateTime.parse(json['timestamp']),
      thermalValue: json['thermal_value'],
      batteryLevel: json['battery_level'],
      memoryUsage: (json['memory_usage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'device_id': deviceId,
      'timestamp': timestamp.toIso8601String(),
      'thermal_value': thermalValue,
      'battery_level': batteryLevel,
      'memory_usage': memoryUsage,
    };
  }
}
