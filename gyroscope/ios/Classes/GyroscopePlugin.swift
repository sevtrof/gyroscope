import CoreMotion
import Flutter

class GyroscopePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var motionManager = CMMotionManager()
    private var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let eventChannel = FlutterEventChannel(name: "gyroscope", binaryMessenger: registrar.messenger())
        let instance = GyroscopePlugin()
        eventChannel.setStreamHandler(instance)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        motionManager.gyroUpdateInterval = 0.1
        motionManager.startGyroUpdates(to: .main) { (data, error) in
            if let data = data {
                events([
                    "x": data.rotationRate.x,
                    "y": data.rotationRate.y,
                    "z": data.rotationRate.z,
                ])
            }
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopGyroUpdates()
        eventSink = nil
        return nil
    }
}
