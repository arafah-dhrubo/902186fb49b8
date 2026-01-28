import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:app/features/vitals/domain/repositories/vitals_repository.dart';
import 'package:equatable/equatable.dart';

class LogVitals implements UseCase<void, LogVitalsParams> {
  final VitalsRepository repository;

  LogVitals(this.repository);

  @override
  Future<Either<Failure, void>> call(LogVitalsParams params) async {
    return await repository.logVitals(params.vitals);
  }
}

class LogVitalsParams extends Equatable {
  final DeviceVitals vitals;

  const LogVitalsParams({required this.vitals});

  @override
  List<Object?> get props => [vitals];
}
