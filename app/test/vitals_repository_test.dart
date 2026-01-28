import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/features/vitals/data/datasources/vitals_local_data_source.dart';
import 'package:app/features/vitals/data/datasources/vitals_remote_data_source.dart';
import 'package:app/features/vitals/data/repositories/vitals_repository_impl.dart';
import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:app/features/vitals/domain/entities/vital_analytics.dart';
import 'package:app/features/vitals/domain/entities/vital_log.dart';
import 'package:app/features/vitals/data/models/vital_log_model.dart';
import 'package:app/features/vitals/data/models/vital_analytics_model.dart';
import 'package:app/features/vitals/data/models/device_vitals_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements VitalsRemoteDataSource {}
class MockLocalDataSource extends Mock implements VitalsLocalDataSource {}

class FakeVitalLogModel extends Fake implements VitalLogModel {}

void main() {
  late VitalsRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  setUpAll(() {
    registerFallbackValue(FakeVitalLogModel());
  });

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = VitalsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('VitalsRepositoryImpl Tests', () {
    const tDeviceId = 'test-device';
    const tVitalsModel = DeviceVitalsModel(
      thermalState: 1,
      batteryLevel: 80,
      memoryUsagePercentage: 45.0,
    );

    test('getCurrentVitals returns Right(DeviceVitals) on success', () async {
      when(() => mockLocal.getVitals()).thenAnswer((_) async => tVitalsModel);

      final result = await repository.getCurrentVitals();

      expect(result, isA<Right<Failure, DeviceVitals>>());
      expect((result as Right).value, tVitalsModel);
      verify(() => mockLocal.getVitals()).called(1);
    });

    test('getHistory returns Right(List<VitalLog>) on success', () async {
      final tLogs = [
        VitalLogModel(
          deviceId: tDeviceId,
          timestamp: DateTime.now(),
          thermalValue: 1,
          batteryLevel: 80,
          memoryUsage: 45.0,
        ),
      ];

      when(() => mockLocal.getDeviceId()).thenAnswer((_) async => tDeviceId);
      when(() => mockRemote.getHistory(tDeviceId)).thenAnswer((_) async => tLogs);

      final result = await repository.getHistory();

      expect(result, isA<Right<Failure, List<VitalLog>>>());
      expect((result as Right).value, tLogs);
      verify(() => mockLocal.getDeviceId()).called(1);
      verify(() => mockRemote.getHistory(tDeviceId)).called(1);
    });

    test('getAnalytics returns Right(VitalAnalytics) on success', () async {
      const tAnalytics = VitalAnalyticsModel(
        avgThermal: 1.5,
        avgBattery: 75.0,
        avgMemory: 40.0,
        totalLogs: 10,
        healthStatus: 'Healthy',
        batteryTrend: 'Stable',
      );

      when(() => mockLocal.getDeviceId()).thenAnswer((_) async => tDeviceId);
      when(() => mockRemote.getAnalytics(tDeviceId)).thenAnswer((_) async => tAnalytics);

      final result = await repository.getAnalytics();

      expect(result, isA<Right<Failure, VitalAnalytics>>());
      expect((result as Right).value, tAnalytics);
      verify(() => mockRemote.getAnalytics(tDeviceId)).called(1);
    });

    test('logVitals returns Right(null) on success', () async {
      when(() => mockLocal.getDeviceId()).thenAnswer((_) async => tDeviceId);
      when(() => mockRemote.logVitals(any())).thenAnswer((_) async => {});

      final result = await repository.logVitals(tVitalsModel);

      expect(result, isA<Right<Failure, void>>());
      verify(() => mockRemote.logVitals(any())).called(1);
    });

    test('returns ServerFailure on remote exception', () async {
      when(() => mockLocal.getDeviceId()).thenAnswer((_) async => tDeviceId);
      when(() => mockRemote.getHistory(tDeviceId)).thenThrow(Exception('API Error'));

      final result = await repository.getHistory();

      expect(result, isA<Left<Failure, List<VitalLog>>>());
    });
  });
}
