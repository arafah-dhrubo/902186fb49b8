import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_cubit.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_state.dart';
import 'package:app/features/vitals/domain/entities/vital_analytics.dart';
import 'package:app/features/vitals/domain/entities/vital_log.dart';
import 'package:app/features/vitals/domain/usecases/get_analytics.dart';
import 'package:app/features/vitals/domain/usecases/get_history.dart';
import 'package:app/features/vitals/presentation/cubits/history_cubit.dart';
import 'package:app/features/vitals/presentation/cubits/history_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHistory extends Mock implements GetHistory {}
class MockGetAnalytics extends Mock implements GetAnalytics {}
class MockConnectivityCubit extends Mock implements ConnectivityCubit {}

void main() {
  late HistoryCubit cubit;
  late MockGetHistory mockGetHistory;
  late MockGetAnalytics mockGetAnalytics;
  late MockConnectivityCubit mockConnectivity;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetHistory = MockGetHistory();
    mockGetAnalytics = MockGetAnalytics();
    mockConnectivity = MockConnectivityCubit();

    when(() => mockConnectivity.state).thenReturn(ConnectionStatus.connected);

    cubit = HistoryCubit(
      getHistory: mockGetHistory,
      getAnalytics: mockGetAnalytics,
      connectivityCubit: mockConnectivity,
    );
  });

  tearDown(() => cubit.close());

  final tLogs = [
    VitalLog(
      deviceId: 'test',
      timestamp: DateTime.now(),
      thermalValue: 1,
      batteryLevel: 90,
      memoryUsage: 40.0,
    ),
  ];

  const tAnalytics = VitalAnalytics(
    avgThermal: 1.0,
    avgBattery: 90.0,
    avgMemory: 40.0,
    totalLogs: 1,
    healthStatus: 'Healthy',
    batteryTrend: 'Stable',
  );

  group('HistoryCubit Tests', () {
    test('initial state should be HistoryInitial', () {
      expect(cubit.state, HistoryInitial());
    });

    blocTest<HistoryCubit, HistoryState>(
      'should emit [Loading, Loaded] when fetching history and analytics succeeds',
      build: () {
        when(() => mockGetHistory(any())).thenAnswer((_) async => Right(tLogs));
        when(() => mockGetAnalytics(any())).thenAnswer((_) async => const Right(tAnalytics));
        return cubit;
      },
      act: (cubit) => cubit.fetchHistory(),
      expect: () => [
        HistoryLoading(),
        HistoryLoaded(logs: tLogs, analytics: tAnalytics),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'should emit [Loading, Error] when fetching fails',
      build: () {
        when(() => mockGetHistory(any())).thenAnswer((_) async => const Left(ServerFailure('Error')));
        when(() => mockGetAnalytics(any())).thenAnswer((_) async => const Right(tAnalytics));
        return cubit;
      },
      act: (cubit) => cubit.fetchHistory(),
      expect: () => [
        HistoryLoading(),
        const HistoryError('Error'),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'should emit [HistoryNoInternet] when offline',
      build: () {
        when(() => mockConnectivity.state).thenReturn(ConnectionStatus.disconnected);
        return cubit;
      },
      act: (cubit) => cubit.fetchHistory(),
      expect: () => [HistoryNoInternet()],
    );
  });
}
