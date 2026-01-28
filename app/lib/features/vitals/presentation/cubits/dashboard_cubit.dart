import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_state.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_cubit.dart';
import 'package:app/features/vitals/domain/usecases/get_current_vitals.dart';
import 'package:app/features/vitals/domain/usecases/log_vitals.dart';
import 'package:app/features/vitals/presentation/cubits/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetCurrentVitals getCurrentVitals;
  final LogVitals logVitals;
  final ConnectivityCubit connectivityCubit;
  
  Timer? _vitalsTimer;
  Timer? _countdownTimer;

  DashboardCubit({
    required this.getCurrentVitals,
    required this.logVitals,
    required this.connectivityCubit,
  }) : super(DashboardInitial());

  void startMonitoring() {
    emit(DashboardLoading());
    _vitalsTimer?.cancel();
    _countdownTimer?.cancel();

    _fetchVitals();
    _startTimers();
  }

  void _startTimers() {
    _vitalsTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchVitals();
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is DashboardLoaded) {
        final current = (state as DashboardLoaded).refreshCountdown;
        if (current <= 1) {
          emit((state as DashboardLoaded).copyWith(refreshCountdown: 5));
        } else {
          emit((state as DashboardLoaded).copyWith(refreshCountdown: current - 1));
        }
      }
    });
  }

  Future<void> _fetchVitals() async {
    final result = await getCurrentVitals(const NoParams());
    
    result.fold(
      (failure) {
        if (state is DashboardLoaded) {
          emit((state as DashboardLoaded).copyWith(error: failure.message));
        } else {
          emit(DashboardError(failure.message));
        }
      },
      (vitals) {
        if (state is DashboardLoaded) {
          emit((state as DashboardLoaded).copyWith(vitals: vitals, error: null));
        } else {
          emit(DashboardLoaded(vitals: vitals));
        }
      },
    );
  }

  Future<void> logCurrentVitals() async {
    if (connectivityCubit.state == ConnectionStatus.disconnected) {
      if (state is DashboardLoaded) {
        emit((state as DashboardLoaded).copyWith(
          isLogging: false,
          error: 'No Internet Connection',
          successMessage: null,
        ));
      } else {
        emit(const DashboardError('No Internet Connection'));
      }
      return;
    }

    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(isLogging: true, successMessage: null));
      
      final result = await logVitals(LogVitalsParams(vitals: currentState.vitals));
      
      result.fold(
        (failure) => emit(currentState.copyWith(
          isLogging: false,
          error: failure.message,
          successMessage: null,
        )),
        (_) => emit(currentState.copyWith(
          isLogging: false,
          error: null,
          successMessage: 'Saved successfully!',
        )),
      );
    }
  }

  @override
  Future<void> close() {
    _vitalsTimer?.cancel();
    _countdownTimer?.cancel();
    return super.close();
  }
}
