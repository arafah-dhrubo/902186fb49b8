import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class RefreshCountdown extends StatelessWidget {
  final int seconds;
  const RefreshCountdown({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            value: seconds / 5,
            strokeWidth: 2,
            backgroundColor: AppTheme.slate900.withValues(alpha: 0.05),
            color: AppTheme.slate900,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Next refresh in ${seconds}s',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
