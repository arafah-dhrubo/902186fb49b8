import 'package:flutter/material.dart';
import 'package:app/core/theme/app_theme.dart';

class AppTextStyles {
  static const TextStyle titleBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppTheme.slate900,
    letterSpacing: -0.2,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppTheme.slate800,
    letterSpacing: -0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.slate800,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.slate600,
    height: 1.4,
  );
}
