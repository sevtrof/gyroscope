#import <Flutter/Flutter.h>
#import <CoreMotion/CoreMotion.h>

@interface GyroscopePlugin : NSObject<FlutterPlugin, FlutterStreamHandler>
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) FlutterEventSink eventSink;
@end
