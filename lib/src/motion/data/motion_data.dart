import 'package:equatable/equatable.dart';
import 'package:gyro_project/src/common/sensor_data.dart';

class MotionData extends Equatable implements SensorData {
  final double gravityX;
  final double gravityY;
  final double gravityZ;

  const MotionData({
    required this.gravityX,
    required this.gravityY,
    required this.gravityZ,
  });

  @override
  List<Object?> get props => [gravityX, gravityY, gravityZ];
}
