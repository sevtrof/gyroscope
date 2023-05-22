import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'motion_method_channel.dart';

abstract class MotionPlatform extends PlatformInterface {
  /// Constructs a MotionPlatform.
  MotionPlatform() : super(token: _token);

  static final Object _token = Object();

  static MotionPlatform _instance = MethodChannelMotion();

  /// The default instance of [MotionPlatform] to use.
  ///
  /// Defaults to [MethodChannelMotion].
  static MotionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MotionPlatform] when
  /// they register themselves.
  static set instance(MotionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
