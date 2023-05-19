#import "GyroscopePlugin.h"
#import <CoreMotion/CoreMotion.h>
#import <Flutter/Flutter.h>

@implementation GyroscopePlugin {
    CMMotionManager *_motionManager;
    FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"gyroscope" binaryMessenger:[registrar messenger]];
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"gyroscopeMethod" binaryMessenger:[registrar messenger]];
  GyroscopePlugin *instance = [[GyroscopePlugin alloc] init];
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    [instance handleMethodCall:call result:result];
  }];
  [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"start" isEqualToString:call.method]) {
        NSNumber *rate = call.arguments[@"rate"];
        _motionManager.gyroUpdateInterval = [rate doubleValue];
        result(nil);
    } else if ([@"stop" isEqualToString:call.method]) {
        [_motionManager stopGyroUpdates];
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
  _motionManager.gyroUpdateInterval = updateInterval;
  if (_motionManager.isGyroAvailable) {
    [_motionManager startGyroUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMGyroData *data, NSError *error) {
      if (data) {
        NSDictionary *gyroData = @{
          @"x": @(data.rotationRate.x),
          @"y": @(data.rotationRate.y),
          @"z": @(data.rotationRate.z)
        };
        _eventSink(gyroData);
      }
    }];
  } else {
    _eventSink([FlutterError errorWithCode:@"NO_GYROSCOPE" message:@"Gyroscope not available" details:nil]);
  }
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  [_motionManager stopGyroUpdates];
  _motionManager = nil;
  _eventSink = nil;
  return nil;
}

@end
