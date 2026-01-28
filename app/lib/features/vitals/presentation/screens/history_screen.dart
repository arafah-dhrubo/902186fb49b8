import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/features/vitals/presentation/cubits/history_cubit.dart';
import 'package:app/features/vitals/presentation/cubits/history_state.dart';
import 'package:app/features/vitals/presentation/widgets/history_analytics_section.dart';
import 'package:app/features/vitals/presentation/widgets/history_log_item.dart';
import 'package:app/core/di/injection_container.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HistoryCubit>()..fetchHistory(),
      child: Scaffold(
        backgroundColor: AppTheme.slate50,
        appBar: AppBar(
          title: const Text('History & Analytics', style: AppTextStyles.titleBold),
          backgroundColor: AppTheme.slate50,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.black));
            }

            if (state is HistoryNoInternet) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 64, color: AppTheme.slate400),
                    gap16,
                    const Text('No Internet Connection', style: AppTextStyles.bodyBold),
                    gap8,
                    TextButton(
                      onPressed: () => context.read<HistoryCubit>().fetchHistory(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HistoryLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<HistoryCubit>().fetchHistory(),
                color: AppTheme.black,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: HistoryAnalyticsSection(analytics: state.analytics),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.mp24px, vertical: 8),
                      sliver: SliverToBoxAdapter(
                        child: Text('Recent Logs', style: AppTextStyles.bodyBold),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.mp20px),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => HistoryLogItem(log: state.logs[index]),
                          childCount: state.logs.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              );
            }

            if (state is HistoryError) {
              return Center(child: Text(state.message, style: AppTextStyles.bodyMedium));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
