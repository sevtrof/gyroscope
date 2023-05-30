import 'dart:async';
import 'package:flutter/services.dart';

class Gyroscope {
  static const EventChannel _eventChannel = EventChannel('gyroscope');
  static const MethodChannel _methodChannel = MethodChannel('gyroscopeMethod');
  Stream<GyroscopeData>? _stream;

  Stream<GyroscopeData> get events {
    _stream ??= _eventChannel.receiveBroadcastStream().map((dynamic event) {
      final Map<dynamic, dynamic> map = event;
      return GyroscopeData(map['x'] as double, map['y'] as double, map['z'] as double);
    });
    return _stream!;
  }

  Future<void> start({double rate = 0.1}) async {
    await _methodChannel.invokeMethod('start', {'rate': rate});
  }

  Future<void> stop() async {
    await _methodChannel.invokeMethod('stop');
  }
}

class GyroscopeData {
  GyroscopeData(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}
