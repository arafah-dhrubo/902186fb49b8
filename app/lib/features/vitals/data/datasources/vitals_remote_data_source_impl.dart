import 'package:dio/dio.dart';
import 'package:app/core/core.dart';
import 'package:app/features/vitals/data/datasources/vitals_remote_data_source.dart';
import 'package:app/features/vitals/data/models/vital_analytics_model.dart';
import 'package:app/features/vitals/data/models/vital_log_model.dart';

class VitalsRemoteDataSourceImpl implements VitalsRemoteDataSource {
  final Dio _dio;

  VitalsRemoteDataSourceImpl(this._dio);

  @override
  Future<void> logVitals(VitalLogModel log) async {
    await _dio.post(ApiConstants.vitals, data: log.toJson());
  }

  @override
  Future<List<VitalLogModel>> getHistory(String deviceId) async {
    final response = await _dio.get(
      ApiConstants.vitals,
      queryParameters: {'device_id': deviceId},
    );
    final List data = response.data;
    return data.map((e) => VitalLogModel.fromJson(e)).toList();
  }

  @override
  Future<VitalAnalyticsModel> getAnalytics(String deviceId) async {
    final response = await _dio.get(
      ApiConstants.analytics,
      queryParameters: {'device_id': deviceId},
    );
    return VitalAnalyticsModel.fromJson(response.data);
  }
}
