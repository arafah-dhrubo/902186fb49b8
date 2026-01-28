import '../models/vital_log_model.dart';
import '../models/vital_analytics_model.dart';

abstract class VitalsRemoteDataSource {
  Future<void> logVitals(VitalLogModel log);
  Future<List<VitalLogModel>> getHistory(String deviceId);
  Future<VitalAnalyticsModel> getAnalytics(String deviceId);
}
