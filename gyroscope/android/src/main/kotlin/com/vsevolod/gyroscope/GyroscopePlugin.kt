package com.vsevolod.gyroscope

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class GyroscopePlugin : FlutterPlugin, EventChannel.StreamHandler, MethodChannel.MethodCallHandler {

  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var sensorManager: SensorManager
  private var sensorEventListener: SensorEventListener? = null
  private var sensor: Sensor? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(binding.binaryMessenger, "gyroscopeMethod")
    eventChannel = EventChannel(binding.binaryMessenger, "gyroscope")
    sensorManager = binding.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    sensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)

    methodChannel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "start" -> {
        val rate = call.argument<Int>("rate") ?: SensorManager.SENSOR_DELAY_NORMAL
        sensorEventListener = createSensorEventListener()
        sensorManager.registerListener(sensorEventListener, sensor, rate)
        result.success(null)
      }
      "stop" -> {
        sensorManager.unregisterListener(sensorEventListener)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    sensorEventListener = createSensorEventListener(events)
  }

  override fun onCancel(arguments: Any?) {
    sensorManager.unregisterListener(sensorEventListener)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    sensorManager.unregisterListener(sensorEventListener)
    sensorEventListener = null
    sensor = null
  }

  private fun createSensorEventListener(events: EventChannel.EventSink? = null): SensorEventListener {
    return object : SensorEventListener {
      override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}
      override fun onSensorChanged(event: SensorEvent) {
        events?.success(mapOf(
          "x" to event.values[0],
          "y" to event.values[1],
          "z" to event.values[2]
        ))
      }
    }
  }
}
