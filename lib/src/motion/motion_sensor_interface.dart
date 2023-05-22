import 'package:gyro_project/src/common/sensor.dart';
import 'package:gyro_project/src/common/utils/sample_rate.dart';
import 'package:gyro_project/src/motion/data/motion_data.dart';

typedef MotionSensorSubscription = Function(
  MotionData data,
);

abstract class MotionSensorInterface extends Sensor {
  @override
  Future<void> subscribe(
    final MotionSensorSubscription subscription, {
    final SampleRate rate,
  });

  @override
  Future<void> unsubscribe();
}
