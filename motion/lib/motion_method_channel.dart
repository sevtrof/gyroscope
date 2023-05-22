import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'motion_platform_interface.dart';

/// An implementation of [MotionPlatform] that uses method channels.
class MethodChannelMotion extends MotionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('motion');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
