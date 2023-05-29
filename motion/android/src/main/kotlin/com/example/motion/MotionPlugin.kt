package com.example.motion

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MotionPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var sensorManager: SensorManager
  private var motionListener: SensorEventListener? = null
  private var motionSensor: Sensor? = null


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    sensorManager = flutterPluginBinding.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    motionSensor = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY)
    MethodChannel(flutterPluginBinding.binaryMessenger, "motionMethodChannel").setMethodCallHandler(this)
    EventChannel(flutterPluginBinding.binaryMessenger, "motionEventChannel").setStreamHandler(this)

    methodChannel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "start" -> {
        val rate = call.argument<Int>("rate") ?: SensorManager.SENSOR_DELAY_NORMAL
        motionListener = createMotionListener()
        sensorManager.registerListener(motionListener, motionSensor, rate)
        result.success(null)
      }
      "stop" -> {
        sensorManager.unregisterListener(motionListener)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    motionListener = createMotionListener(events)
  }

  override fun onCancel(arguments: Any?) {
    sensorManager.unregisterListener(motionListener)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    sensorManager.unregisterListener(motionListener)
    motionListener = null
    motionSensor = null
  }

  private fun createMotionListener(events: EventChannel.EventSink? = null): SensorEventListener {
    return object : SensorEventListener {
      override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
      override fun onSensorChanged(event: SensorEvent) {
        events?.success(hashMapOf(
          "gravityX" to event.values[0],
          "gravityY" to event.values[1],
          "gravityZ" to event.values[2]
        ))
      }
    }
  }
}
