import 'package:app/core/core.dart';
import 'package:flutter/material.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;
  const DashboardErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.mp24px),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppTheme.primaryRed,
            ),
            gap16,
            Text(
              'Something went wrong',
              style: AppTextStyles.titleBold.copyWith(fontSize: 20),
            ),
            gap8,
            Text(
              message,
              style: AppTextStyles.bodyRegular.copyWith(
                fontSize: 12,
                color: AppTheme.slate400,
              ),
              textAlign: TextAlign.center,
            ),
            gap24,
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                // This will be handled by the parent's refresh mechanism if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
