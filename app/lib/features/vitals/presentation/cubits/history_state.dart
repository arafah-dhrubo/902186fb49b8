import 'package:equatable/equatable.dart';
import '../../domain/entities/vital_analytics.dart';
import '../../domain/entities/vital_log.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<VitalLog> logs;
  final VitalAnalytics analytics;

  const HistoryLoaded({required this.logs, required this.analytics});

  @override
  List<Object?> get props => [logs, analytics];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class HistoryNoInternet extends HistoryState {}
