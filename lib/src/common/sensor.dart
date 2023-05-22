import 'package:gyro_project/src/common/utils/sample_rate.dart';
import 'package:gyro_project/src/common/sensor_data.dart';

abstract class Sensor {
  Future<void> subscribe(
    final Function(SensorData data) subscription, {
    final SampleRate rate,
  });

  Future<void> unsubscribe();
}
