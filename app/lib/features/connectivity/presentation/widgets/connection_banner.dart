import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_cubit.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_state.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectionStatus>(
      builder: (context, state) {
        if (state == ConnectionStatus.initial ||
            state == ConnectionStatus.connected) {
          return const SizedBox.shrink();
        }

        final isDisconnected = state == ConnectionStatus.disconnected;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 40,
          color: isDisconnected ? AppTheme.primaryRed : Colors.green,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDisconnected ? Icons.wifi_off : Icons.wifi,
                  color: AppTheme.white,
                  size: 16,
                ),
                gap8,
                Text(
                  isDisconnected ? 'No Internet Connection' : 'Connected',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
