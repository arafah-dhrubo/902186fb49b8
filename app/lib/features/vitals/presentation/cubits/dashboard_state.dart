import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DeviceVitals vitals;
  final bool isLogging;
  final String? error;
  final String? successMessage;
  final int refreshCountdown;

  const DashboardLoaded({
    required this.vitals,
    this.isLogging = false,
    this.error,
    this.successMessage,
    this.refreshCountdown = 5,
  });

  DashboardLoaded copyWith({
    DeviceVitals? vitals,
    bool? isLogging,
    String? error,
    String? successMessage,
    int? refreshCountdown,
  }) {
    return DashboardLoaded(
      vitals: vitals ?? this.vitals,
      isLogging: isLogging ?? this.isLogging,
      error: error,
      successMessage: successMessage,
      refreshCountdown: refreshCountdown ?? this.refreshCountdown,
    );
  }

  @override
  List<Object?> get props => [
    vitals,
    isLogging,
    error,
    successMessage,
    refreshCountdown,
  ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
