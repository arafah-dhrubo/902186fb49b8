import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/features/vitals/presentation/cubits/dashboard_cubit.dart';
import 'package:app/features/vitals/presentation/cubits/dashboard_state.dart';
import 'package:app/features/vitals/presentation/widgets/refresh_countdown.dart';
import 'package:app/features/vitals/presentation/widgets/vital_card.dart';
import 'package:app/features/vitals/presentation/widgets/custom_button.dart';

class DashboardContentView extends StatelessWidget {
  final DashboardLoaded state;
  const DashboardContentView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final vitals = state.vitals;

    return RefreshIndicator(
      onRefresh: () async => context.read<DashboardCubit>().startMonitoring(),
      color: AppTheme.black,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.mp20px),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.mp24px,
              vertical: AppSizes.mp8px,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Metrics',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                RefreshCountdown(seconds: state.refreshCountdown),
              ],
            ),
          ),
          VitalCard(
            title: 'Thermal',
            value: vitals.thermalStateString,
            unit: ' (${vitals.thermalState})',
            icon: Icons.thermostat_auto_rounded,
            valueColor: _getThermalColor(vitals.thermalState),
          ),
          VitalCard(
            title: 'Battery',
            value: vitals.batteryLevelString,
            unit: vitals.isBatteryAvailable ? '' : '',
            icon: Icons.battery_charging_full_rounded,
            valueColor: vitals.isBatteryAvailable && vitals.batteryLevel < 20
                ? AppTheme.primaryRed
                : null,
          ),
          VitalCard(
            title: 'Memory Usage',
            value: vitals.memoryUsagePercentage.toStringAsFixed(1),
            unit: '%',
            icon: Icons.memory_rounded,
          ),
          SizedBox(height: AppSizes.mp24px),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.mp20px),
            child: CustomButton(
              text: 'Save to Cloud',
              icon: Icons.cloud_done_rounded,
              isLoading: state.isLogging,
              onPressed: () =>
                  context.read<DashboardCubit>().logCurrentVitals(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getThermalColor(int state) {
    switch (state) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 3:
        return AppTheme.primaryRed;
      default:
        return AppTheme.black;
    }
  }
}
