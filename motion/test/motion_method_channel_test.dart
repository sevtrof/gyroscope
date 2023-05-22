import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion/motion_method_channel.dart';

void main() {
  MethodChannelMotion platform = MethodChannelMotion();
  const MethodChannel channel = MethodChannel('motion');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
