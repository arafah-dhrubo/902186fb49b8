import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_cubit.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_state.dart';
import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:app/features/vitals/domain/usecases/get_current_vitals.dart';
import 'package:app/features/vitals/domain/usecases/log_vitals.dart';
import 'package:app/features/vitals/presentation/cubits/dashboard_cubit.dart';
import 'package:app/features/vitals/presentation/cubits/dashboard_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentVitals extends Mock implements GetCurrentVitals {}
class MockLogVitals extends Mock implements LogVitals {}
class MockConnectivityCubit extends Mock implements ConnectivityCubit {}

class FakeLogVitalsParams extends Fake implements LogVitalsParams {}

void main() {
  late DashboardCubit cubit;
  late MockGetCurrentVitals mockGetVitals;
  late MockLogVitals mockLogVitals;
  late MockConnectivityCubit mockConnectivity;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(FakeLogVitalsParams());
  });

  setUp(() {
    mockGetVitals = MockGetCurrentVitals();
    mockLogVitals = MockLogVitals();
    mockConnectivity = MockConnectivityCubit();
    
    when(() => mockConnectivity.state).thenReturn(ConnectionStatus.connected);
    
    cubit = DashboardCubit(
      getCurrentVitals: mockGetVitals,
      logVitals: mockLogVitals,
      connectivityCubit: mockConnectivity,
    );
  });

  tearDown(() => cubit.close());

  const tVitals = DeviceVitals(
    thermalState: 1,
    batteryLevel: 80,
    memoryUsagePercentage: 45.0,
  );

  group('DashboardCubit Tests', () {
    test('initial state should be DashboardInitial', () {
      expect(cubit.state, DashboardInitial());
    });

    blocTest<DashboardCubit, DashboardState>(
      'should emit [Loading, Loaded] when fetching vitals succeeds',
      build: () {
        when(() => mockGetVitals(any())).thenAnswer((_) async => const Right(tVitals));
        return cubit;
      },
      act: (cubit) => cubit.startMonitoring(),
      expect: () => [
        DashboardLoading(),
        const DashboardLoaded(vitals: tVitals),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'should emit [Loading, Error] when fetching vitals fails',
      build: () {
        when(() => mockGetVitals(any())).thenAnswer((_) async => const Left(ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.startMonitoring(),
      expect: () => [
        DashboardLoading(),
        const DashboardError('Error'),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'should emit [isLogging=true, isLogging=false] when logging succeeds',
      build: () {
        when(() => mockLogVitals(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      seed: () => const DashboardLoaded(vitals: tVitals),
      act: (cubit) => cubit.logCurrentVitals(),
      expect: () => [
        const DashboardLoaded(vitals: tVitals, isLogging: true),
        const DashboardLoaded(vitals: tVitals, isLogging: false, successMessage: 'Saved successfully!'),
      ],
    );
  });
}
