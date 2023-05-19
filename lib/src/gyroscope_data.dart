import 'dart:math';

import 'package:equatable/equatable.dart';

class GyroscopeData extends Equatable {
  // Rotation on the axis from the back to the front side of the phone
  final double azimuth;

  // Rotation on the axis from the left to the right side of the phone
  final double pitch;

  // Rotation on the axis from the bottom to the top of the phone
  final double roll;

  GyroscopeData({
    double? azimuth,
    double? pitch,
    double? roll,
  })  : azimuth = _normalizeAngle(azimuth ?? 0.0),
        pitch = _normalizeAngle(pitch ?? 0.0),
        roll = _normalizeAngle(roll ?? 0.0);

  static double _normalizeAngle(double angle) {
    double newAngle = angle % (2 * pi);
    // Transform the range from [0, 2pi] to [-pi, pi].
    if (newAngle > pi) {
      newAngle -= 2 * pi;
    } else if (newAngle < -pi) {
      newAngle += 2 * pi;
    }
    return newAngle;
  }

  @override
  List<Object> get props => [azimuth, pitch, roll];
}
