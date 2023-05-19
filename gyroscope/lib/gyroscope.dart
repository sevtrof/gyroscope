import 'dart:async';
import 'package:flutter/services.dart';

class Gyroscope {
  static const EventChannel _channel = EventChannel('gyroscope');
  Stream<GyroscopeData>? _stream;



  Stream<GyroscopeData> get events {
    _stream ??= _channel.receiveBroadcastStream().map((dynamic event) {
      final Map<dynamic, dynamic> map = event;
      return GyroscopeData(map['x'] as double, map['y'] as double, map['z'] as double);
    });
    return _stream!;
  }
}

class GyroscopeData {
  GyroscopeData(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}
