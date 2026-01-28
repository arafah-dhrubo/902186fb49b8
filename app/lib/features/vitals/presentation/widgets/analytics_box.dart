import 'package:app/core/core.dart';
import 'package:flutter/material.dart';

class AnalyticsBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const AnalyticsBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.mp8px,
          vertical: AppSizes.mp16px,
        ),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.hardEdge,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.slate50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.slate800, size: 25),
              ),
              gap16,
              Text(
                value,
                style: AppTextStyles.titleBold.copyWith(
                  fontSize: 20,
                  color: AppTheme.slate900,
                ),
              ),
              gap4,
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 11,
                  color: AppTheme.slate400,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
