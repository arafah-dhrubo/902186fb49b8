import '../models/device_vitals_model.dart';

abstract class VitalsLocalDataSource {
  Future<DeviceVitalsModel> getVitals();
  Future<String> getDeviceId();
}
