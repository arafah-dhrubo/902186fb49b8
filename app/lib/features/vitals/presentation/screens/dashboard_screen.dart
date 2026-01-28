import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/features/vitals/presentation/cubits/dashboard_cubit.dart';
import 'package:app/features/vitals/presentation/cubits/dashboard_state.dart';
import 'package:app/features/vitals/presentation/widgets/dashboard_content_view.dart';
import 'package:app/features/vitals/presentation/widgets/dashboard_error_view.dart';
import 'package:app/features/connectivity/presentation/widgets/connection_banner.dart';
import 'package:app/core/di/injection_container.dart';
import 'package:app/features/vitals/presentation/screens/history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..startMonitoring(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vital Monitor'),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                child: Chip(
                  label: const Text(
                    'History',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const ConnectionBanner(),
            Expanded(
              child: BlocConsumer<DashboardCubit, DashboardState>(
                listener: (context, state) {
                  if (state is DashboardLoaded) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error!),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppTheme.primaryRed,
                        ),
                      );
                    } else if (state.successMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.successMessage!),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  if (state is DashboardLoading || state is DashboardInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.black),
                    );
                  }

                  if (state is DashboardError) {
                    return DashboardErrorView(message: state.message);
                  }

                  if (state is DashboardLoaded) {
                    return DashboardContentView(state: state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
