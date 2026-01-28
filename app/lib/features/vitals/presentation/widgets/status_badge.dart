import 'package:app/core/core.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatusBadge({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 9,
                  color: AppTheme.slate400,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyBold.copyWith(
                  fontSize: 12,
                  color: AppTheme.slate800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
