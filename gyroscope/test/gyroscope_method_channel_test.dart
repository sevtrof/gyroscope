import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyroscope/gyroscope_method_channel.dart';

void main() {
  MethodChannelGyroscope platform = MethodChannelGyroscope();
  const MethodChannel channel = MethodChannel('gyroscope');

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
