import 'package:app/core/error/failures.dart';
import 'package:app/core/types/either.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/vitals/domain/entities/vital_analytics.dart';
import 'package:app/features/vitals/domain/repositories/vitals_repository.dart';

class GetAnalytics implements UseCase<VitalAnalytics, NoParams> {
  final VitalsRepository repository;

  GetAnalytics(this.repository);

  @override
  Future<Either<Failure, VitalAnalytics>> call(NoParams params) async {
    return await repository.getAnalytics();
  }
}
