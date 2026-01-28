import 'package:app/core/core.dart';
import 'package:app/features/vitals/domain/entities/vital_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryLogItem extends StatelessWidget {
  final VitalLog log;

  const HistoryLogItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(log.thermalValue);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.mp12px),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            _getThermalIcon(log.thermalValue),
            size: 22,
            color: statusColor,
          ),
        ),
        title: Text(
          'Battery: ${log.batteryLevel.toInt()}% | Memory: ${log.memoryUsage.toStringAsFixed(1)}%',
          style: AppTextStyles.bodyBold.copyWith(
            fontSize: 14,
            color: AppTheme.slate900,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: AppTheme.slate400,
              ),
              gap4,
              Text(
                DateFormat('MMM d, HH:mm:ss').format(log.timestamp),
                style: AppTextStyles.bodyRegular.copyWith(
                  fontSize: 12,
                  color: AppTheme.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(int thermalValue) {
    if (thermalValue >= 3) return AppTheme.primaryRed;
    if (thermalValue == 2) return Colors.deepOrange;
    return Colors.green;
  }

  IconData _getThermalIcon(int value) {
    if (value >= 3) return Icons.warning_rounded;
    if (value >= 2) return Icons.hot_tub_rounded;
    return Icons.check_circle_outline_rounded;
  }
}
