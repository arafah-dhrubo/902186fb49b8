import 'package:app/core/core.dart';
import 'package:app/features/vitals/domain/entities/vital_analytics.dart';
import 'package:app/features/vitals/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

import 'package:app/features/vitals/presentation/widgets/analytics_box.dart';

class HistoryAnalyticsSection extends StatelessWidget {
  final VitalAnalytics analytics;

  const HistoryAnalyticsSection({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.mp24px,
        vertical: AppSizes.mp16px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Analytics', style: AppTextStyles.titleBold),
              Row(
                children: [
                  StatusBadge(
                    label: 'Health',
                    value: analytics.healthStatus,
                    icon: _getHealthIcon(analytics.healthStatus),
                    color: _getHealthColor(analytics.healthStatus),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(
                    label: 'Trend',
                    value: analytics.batteryTrend,
                    icon: _getTrendIcon(analytics.batteryTrend),
                    color: _getTrendColor(analytics.batteryTrend),
                  ),
                ],
              ),
            ],
          ),
          gap12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnalyticsBox(
                label: 'Avg. Thermal',
                value: analytics.avgThermal.toStringAsFixed(1),
                icon: Icons.thermostat,
              ),
              gap8,
              AnalyticsBox(
                label: 'Avg. Battery',
                value: '${analytics.avgBattery.toInt()}%',
                icon: Icons.battery_std,
              ),
              gap8,
              AnalyticsBox(
                label: 'Avg. Memory',
                value: '${analytics.avgMemory.toInt()}%',
                icon: Icons.memory,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getHealthIcon(String status) {
    if (status.contains('Healthy')) return Icons.check_circle_rounded;
    if (status.contains('Stress')) return Icons.bolt_rounded;
    return Icons.warning_rounded;
  }

  Color _getHealthColor(String status) {
    if (status.contains('Healthy')) return Colors.green;
    if (status.contains('Stress')) return Colors.orange;
    return AppTheme.primaryRed;
  }

  IconData _getTrendIcon(String trend) {
    if (trend == 'Charging') return Icons.battery_charging_full_rounded;
    if (trend == 'Draining') return Icons.battery_alert_rounded;
    return Icons.battery_std_rounded;
  }

  Color _getTrendColor(String trend) {
    if (trend == 'Charging') return Colors.blue;
    if (trend == 'Draining') return Colors.orange;
    return AppTheme.slate600;
  }
}
