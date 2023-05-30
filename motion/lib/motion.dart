import 'dart:async';
import 'package:flutter/services.dart';

class Motion {
  static const EventChannel _eventChannel = EventChannel('motionEventChannel');
  static const MethodChannel _methodChannel = MethodChannel('motionMethodChannel');
  Stream<MotionData>? _stream;

  Stream<MotionData> get events {
    _stream ??= _eventChannel.receiveBroadcastStream().map((dynamic event) {
      final Map<dynamic, dynamic> map = event;
      return MotionData(map['gravityX'] as double, map['gravityY'] as double, map['gravityZ'] as double);
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

class MotionData {
  MotionData(this.gravityX, this.gravityY, this.gravityZ);

  final double gravityX;
  final double gravityY;
  final double gravityZ;
}
