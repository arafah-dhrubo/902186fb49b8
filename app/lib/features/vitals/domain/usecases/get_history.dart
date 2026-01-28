import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/vitals/domain/entities/vital_log.dart';
import 'package:app/features/vitals/domain/repositories/vitals_repository.dart';

class GetHistory implements UseCase<List<VitalLog>, NoParams> {
  final VitalsRepository repository;

  GetHistory(this.repository);

  @override
  Future<Either<Failure, List<VitalLog>>> call(NoParams params) async {
    return await repository.getHistory();
  }
}
