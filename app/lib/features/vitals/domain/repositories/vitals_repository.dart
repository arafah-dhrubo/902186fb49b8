import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:app/features/vitals/domain/entities/vital_analytics.dart';
import 'package:app/features/vitals/domain/entities/vital_log.dart';

abstract class VitalsRepository {
  Future<Either<Failure, DeviceVitals>> getCurrentVitals();
  Future<Either<Failure, void>> logVitals(DeviceVitals vitals);
  Future<Either<Failure, List<VitalLog>>> getHistory();
  Future<Either<Failure, VitalAnalytics>> getAnalytics();
}
