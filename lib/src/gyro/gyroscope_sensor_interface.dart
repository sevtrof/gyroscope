import 'package:gyro_project/src/common/sensor.dart';
import 'package:gyro_project/src/common/utils/sample_rate.dart';
import 'package:gyro_project/src/gyro/data/gyroscope_data.dart';

typedef GyroscopeSensorSubscription = Function(
  GyroscopeData data,
);

abstract class GyroscopeSensorInterface extends Sensor {
  @override
  Future<void> subscribe(
    final GyroscopeSensorSubscription subscription, {
    final SampleRate rate,
  });

  @override
  Future<void> unsubscribe();
}
