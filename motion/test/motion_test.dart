import 'package:flutter_test/flutter_test.dart';
import 'package:motion/motion.dart';
import 'package:motion/motion_platform_interface.dart';
import 'package:motion/motion_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMotionPlatform
    with MockPlatformInterfaceMixin
    implements MotionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MotionPlatform initialPlatform = MotionPlatform.instance;

  test('$MethodChannelMotion is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMotion>());
  });

  test('getPlatformVersion', () async {
    Motion motionPlugin = Motion();
    MockMotionPlatform fakePlatform = MockMotionPlatform();
    MotionPlatform.instance = fakePlatform;
  });
}
