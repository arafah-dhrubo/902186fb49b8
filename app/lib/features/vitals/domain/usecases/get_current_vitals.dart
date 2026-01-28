import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/vitals/domain/entities/device_vitals.dart';
import 'package:app/features/vitals/domain/repositories/vitals_repository.dart';

class GetCurrentVitals implements UseCase<DeviceVitals, NoParams> {
  final VitalsRepository repository;

  GetCurrentVitals(this.repository);

  @override
  Future<Either<Failure, DeviceVitals>> call(NoParams params) async {
    return await repository.getCurrentVitals();
  }
}
