import 'package:equatable/equatable.dart';

class DeviceVitals extends Equatable {
  final int thermalState;
  final int batteryLevel;
  final double memoryUsagePercentage;

  const DeviceVitals({
    required this.thermalState,
    required this.batteryLevel,
    required this.memoryUsagePercentage,
  });

  bool get isBatteryAvailable => batteryLevel >= 0;

  String get batteryLevelString => isBatteryAvailable ? '$batteryLevel%' : 'N/A';

  String get thermalStateString {
    switch (thermalState) {
      case 0: return 'Nominal';
      case 1: return 'Fair';
      case 2: return 'Serious';
      case 3: return 'Critical';
      default: return 'Unknown';
    }
  }

  @override
  List<Object?> get props => [thermalState, batteryLevel, memoryUsagePercentage];
}
