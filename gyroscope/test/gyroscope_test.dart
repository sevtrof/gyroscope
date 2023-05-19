import 'package:flutter_test/flutter_test.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:gyroscope/gyroscope_platform_interface.dart';
import 'package:gyroscope/gyroscope_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGyroscopePlatform
    with MockPlatformInterfaceMixin
    implements GyroscopePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GyroscopePlatform initialPlatform = GyroscopePlatform.instance;

  test('$MethodChannelGyroscope is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGyroscope>());
  });

  test('getPlatformVersion', () async {
    Gyroscope gyroscopePlugin = Gyroscope();
    MockGyroscopePlatform fakePlatform = MockGyroscopePlatform();
    GyroscopePlatform.instance = fakePlatform;

  });
}
