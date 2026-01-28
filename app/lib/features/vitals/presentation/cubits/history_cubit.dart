import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_state.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_cubit.dart';
import 'package:app/features/vitals/domain/usecases/get_analytics.dart';
import 'package:app/features/vitals/domain/usecases/get_history.dart';
import 'package:app/features/vitals/presentation/cubits/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistory getHistory;
  final GetAnalytics getAnalytics;
  final ConnectivityCubit connectivityCubit;

  HistoryCubit({
    required this.getHistory,
    required this.getAnalytics,
    required this.connectivityCubit,
  }) : super(HistoryInitial());

  Future<void> fetchHistory() async {
    if (connectivityCubit.state == ConnectionStatus.disconnected) {
      emit(HistoryNoInternet());
      return;
    }

    emit(HistoryLoading());
    
    final historyResult = await getHistory(const NoParams());
    final analyticsResult = await getAnalytics(const NoParams());

    historyResult.fold(
      (failure) => emit(HistoryError(failure.message)),
      (logs) {
        analyticsResult.fold(
          (failure) => emit(HistoryError(failure.message)),
          (analytics) => emit(HistoryLoaded(logs: logs, analytics: analytics)),
        );
      },
    );
  }
}
