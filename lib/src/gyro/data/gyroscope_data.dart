import 'package:equatable/equatable.dart';
import 'package:gyro_project/src/common/sensor_data.dart';

class GyroscopeData extends Equatable implements SensorData {
  final double azimuth;
  final double pitch;
  final double roll;

  const GyroscopeData({
    required this.azimuth,
    required this.pitch,
    required this.roll,
  });

  @override
  List<Object> get props => [azimuth, pitch, roll];
}
