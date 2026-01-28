import '../../domain/entities/vital_analytics.dart';

class VitalAnalyticsModel extends VitalAnalytics {
  const VitalAnalyticsModel({
    required super.avgThermal,
    required super.avgBattery,
    required super.avgMemory,
    required super.totalLogs,
    super.healthStatus,
    super.batteryTrend,
  });

  factory VitalAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return VitalAnalyticsModel(
      avgThermal: (json['avg_thermal'] as num).toDouble(),
      avgBattery: (json['avg_battery'] as num).toDouble(),
      avgMemory: (json['avg_memory'] as num).toDouble(),
      totalLogs: json['sample_size'],
      healthStatus: json['health_status'] ?? 'N/A',
      batteryTrend: json['battery_trend'] ?? 'N/A',
    );
  }
}
