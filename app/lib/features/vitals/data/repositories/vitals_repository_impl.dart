import 'package:dio/dio.dart';
import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:app/features/vitals/domain/entities/vital_analytics.dart';
import 'package:app/features/vitals/domain/entities/vital_log.dart';
import 'package:app/features/vitals/domain/repositories/vitals_repository.dart';
import 'package:app/features/vitals/data/datasources/vitals_local_data_source.dart';
import 'package:app/features/vitals/data/datasources/vitals_remote_data_source.dart';
import 'package:app/features/vitals/data/models/vital_log_model.dart';

class VitalsRepositoryImpl implements VitalsRepository {
  final VitalsRemoteDataSource remoteDataSource;
  final VitalsLocalDataSource localDataSource;

  VitalsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, DeviceVitals>> getCurrentVitals() async {
    try {
      final vitals = await localDataSource.getVitals();
      return Right(vitals);
    } catch (e) {
      return Left(DeviceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logVitals(DeviceVitals vitals) async {
    try {
      final deviceId = await localDataSource.getDeviceId();
      
      // Clamp values to server-accepted ranges
      final thermal = vitals.thermalState.clamp(0, 3);
      final battery = vitals.batteryLevel.clamp(0, 100);
      final memory = vitals.memoryUsagePercentage.clamp(0.0, 100.0);

      final model = VitalLogModel(
        deviceId: deviceId,
        timestamp: DateTime.now().toUtc(),
        thermalValue: thermal,
        batteryLevel: battery,
        memoryUsage: memory,
      );
      
      await remoteDataSource.logVitals(model);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VitalLog>>> getHistory() async {
    try {
      final deviceId = await localDataSource.getDeviceId();
      final history = await remoteDataSource.getHistory(deviceId);
      return Right(history);
    } on DioException catch (e) {
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VitalAnalytics>> getAnalytics() async {
    try {
      final deviceId = await localDataSource.getDeviceId();
      final analytics = await remoteDataSource.getAnalytics(deviceId);
      return Right(analytics);
    } on DioException catch (e) {
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError) return 'Could not connect to server.';
    if (e.type == DioExceptionType.connectionTimeout) return 'Connection timed out.';
    return 'Network Error: ${e.message}';
  }
}
