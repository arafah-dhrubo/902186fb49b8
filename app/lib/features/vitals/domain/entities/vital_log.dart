import 'package:equatable/equatable.dart';

class VitalLog extends Equatable {
  final String? id;
  final String deviceId;
  final DateTime timestamp;
  final int thermalValue;
  final int batteryLevel;
  final double memoryUsage;

  const VitalLog({
    this.id,
    required this.deviceId,
    required this.timestamp,
    required this.thermalValue,
    required this.batteryLevel,
    required this.memoryUsage,
  });

  @override
  List<Object?> get props => [
    id,
    deviceId,
    timestamp,
    thermalValue,
    batteryLevel,
    memoryUsage,
  ];
}
