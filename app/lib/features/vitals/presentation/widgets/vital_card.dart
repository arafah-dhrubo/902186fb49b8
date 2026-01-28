import 'package:app/core/core.dart';
import 'package:flutter/material.dart';

class VitalCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color? valueColor;

  const VitalCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.mp20px,
        vertical: AppSizes.mp8px,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.mp20px,
          vertical: AppSizes.mp24px,
        ),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: (valueColor ?? AppTheme.primaryRed).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: valueColor ?? AppTheme.primaryRed,
                size: AppSizes.iconMedium + 4,
              ),
            ),
            gap20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: AppTheme.slate400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  gap4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: AppTextStyles.titleBold.copyWith(
                          fontSize: 28,
                          color: valueColor ?? AppTheme.slate900,
                          letterSpacing: -1,
                        ),
                      ),
                      gap4,
                      Text(
                        unit,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          color: AppTheme.slate400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
