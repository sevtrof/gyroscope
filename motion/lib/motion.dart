import 'dart:async';
import 'package:flutter/services.dart';

class Motion {
  static const EventChannel _channel = EventChannel('motionEventChannel');
  Stream<MotionData>? _stream;

  Stream<MotionData> get events {
    _stream ??= _channel.receiveBroadcastStream().map((dynamic event) {
      final Map<dynamic, dynamic> map = event;
      return MotionData(map['gravityX'] as double, map['gravityY'] as double, map['gravityZ'] as double);
    });
    return _stream!;
  }
}

class MotionData {
  MotionData(this.gravityX, this.gravityY, this.gravityZ);

  final double gravityX;
  final double gravityY;
  final double gravityZ;
}
