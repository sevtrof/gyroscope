import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gyro_project/src/common/exceptions.dart';
import 'package:gyro_project/src/common/sensor.dart';
import 'package:gyro_project/src/common/utils/sample_rate.dart';
import 'package:gyro_project/src/motion/data/motion_data.dart';
import 'package:gyro_project/src/motion/motion_sensor_interface.dart';

class MotionSensorImpl implements Sensor {
  static const MethodChannel _channel = MethodChannel('motionMethodChannel');
  static const EventChannel _eventChannel = EventChannel('motionEventChannel');
  StreamSubscription<MotionData>? _motionSubscription;

  @override
  Future<void> subscribe(
    MotionSensorSubscription motionSubscription, {
    SampleRate rate = SampleRate.normal,
  }) async {
    try {
      await _channel.invokeMethod('start', {"rate": rate.toHz()});

      _motionSubscription = _eventChannel.receiveBroadcastStream().map((event) {
        if (event is FlutterError) {
          throw SensorException(event.message);
        }
        return MotionData(
          gravityX: event['gravityX'],
          gravityY: event['gravityY'],
          gravityZ: event['gravityZ'],
        );
      }).listen(motionSubscription, onError: (error) {
        if (error is SensorException) {
          print('Error: ${error.message}');
        }
      });
    } catch (error) {
      throw SensorException(
          'Failed to subscribe to gyroscope and motion updates.');
    }
  }

  @override
  Future<void> unsubscribe() async {
    try {
      await _channel.invokeMethod('stop');
      await _motionSubscription?.cancel();
    } catch (error) {
      throw SensorException(
          'Failed to unsubscribe from gyroscope and motion updates.');
    }
  }
}
