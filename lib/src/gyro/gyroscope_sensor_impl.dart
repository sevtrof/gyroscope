import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gyro_project/src/common/exceptions.dart';
import 'package:gyro_project/src/common/sensor.dart';
import 'package:gyro_project/src/common/utils/sample_rate.dart';
import 'package:gyro_project/src/gyro/data/gyroscope_data.dart';
import 'package:gyro_project/src/gyro/gyroscope_sensor_interface.dart';

class GyroscopeSensorImpl implements Sensor {
  static const MethodChannel _channel = MethodChannel('gyroscopeMethod');
  static const EventChannel _eventChannel = EventChannel('gyroscope');
  StreamSubscription<GyroscopeData>? _subscription;

  @override
  Future<void> subscribe(
    GyroscopeSensorSubscription subscription, {
    SampleRate rate = SampleRate.normal,
  }) async {
    try {
      await _channel.invokeMethod('start', {"rate": rate.toHz()});
      _subscription = _eventChannel.receiveBroadcastStream().map((event) {
        if (event is FlutterError) {
          throw SensorException(event.message);
        }
        return GyroscopeData(
          azimuth: event['x'],
          pitch: event['y'],
          roll: event['z'],
        );
      }).listen(subscription, onError: (error) {
        if (error is SensorException) {
          print('Error: ${error.message}');
        }
      });
    } catch (error) {
      throw SensorException('Failed to subscribe to gyroscope updates.');
    }
  }

  @override
  Future<void> unsubscribe() async {
    try {
      await _channel.invokeMethod('stop');
      await _subscription?.cancel();
    } catch (error) {
      throw SensorException('Failed to unsubscribe from gyroscope updates.');
    }
  }
}
