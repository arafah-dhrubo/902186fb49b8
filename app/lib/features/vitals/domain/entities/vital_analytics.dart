import 'package:equatable/equatable.dart';

class VitalAnalytics extends Equatable {
  final double avgThermal;
  final double avgBattery;
  final double avgMemory;
  final int totalLogs;
  final String healthStatus;
  final String batteryTrend;

  const VitalAnalytics({
    required this.avgThermal,
    required this.avgBattery,
    required this.avgMemory,
    required this.totalLogs,
    this.healthStatus = 'N/A',
    this.batteryTrend = 'N/A',
  });

  @override
  List<Object?> get props => [avgThermal, avgBattery, avgMemory, totalLogs, healthStatus, batteryTrend];
}
