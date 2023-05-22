#import "MotionPlugin.h"
#import <CoreMotion/CoreMotion.h>
#import <Flutter/Flutter.h>

@implementation MotionPlugin {
    CMMotionManager *_motionManager;
    FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"motionEventChannel" binaryMessenger:[registrar messenger]];
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"motionMethodChannel" binaryMessenger:[registrar messenger]];
  MotionPlugin *instance = [[MotionPlugin alloc] init];
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    [instance handleMethodCall:call result:result];
  }];
  [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"start" isEqualToString:call.method]) {
        NSNumber *rate = call.arguments[@"rate"];
        _motionManager.deviceMotionUpdateInterval = [rate doubleValue];
        result(nil);
    } else if ([@"stop" isEqualToString:call.method]) {
        [_motionManager stopDeviceMotionUpdates];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  _eventSink = events;
  _motionManager = [[CMMotionManager alloc] init];
  double updateInterval = 0.1;
  if (arguments && [arguments isKindOfClass:[NSDictionary class]]) {
    NSNumber *rate = arguments[@"rate"];
    if (rate && [rate isKindOfClass:[NSNumber class]]) {
      updateInterval = rate.doubleValue;
    }
  }
  _motionManager.deviceMotionUpdateInterval = updateInterval;
  if (_motionManager.isDeviceMotionAvailable) {
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMDeviceMotion *data, NSError *error) {
      if (data) {
        NSDictionary *motionData = @{
          @"gravityX": @(data.gravity.x),
          @"gravityY": @(data.gravity.y),
          @"gravityZ": @(data.gravity.z),
        };
        _eventSink(motionData);
      }
    }];
  } else {
    _eventSink([FlutterError errorWithCode:@"NO_MOTION" message:@"Device motion not available" details:nil]);
  }
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  [_motionManager stopDeviceMotionUpdates];
  _motionManager = nil;
  _eventSink = nil;
  return nil;
}

@end
