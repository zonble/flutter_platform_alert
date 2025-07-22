package net.zonble.flutter_platform_alert

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.media.RingtoneManager
import android.os.Build
import android.util.Base64
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterPlatformAlertPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private var activity: Activity? = null
  private var context: Context? = null
  private lateinit var channel: MethodChannel

  @Suppress("UNCHECKED_CAST")
  @RequiresApi(Build.VERSION_CODES.N)
  override fun onMethodCall(call: MethodCall, result: Result): Unit =
    when (call.method) {
      "playAlertSound" -> {
        try {
          var notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
          if (notification == null) {
            // Fallback to alarm sound if notification sound is not available
            notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
          }
          if (notification == null) {
            // Final fallback to ringtone
            notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
          }
          
          if (notification != null && this.context != null) {
            val ringTone = RingtoneManager.getRingtone(this.context, notification)
            if (ringTone != null) {
              ringTone.play()
              result.success(null)
            } else {
              result.error("SOUND_ERROR", "Unable to create ringtone from URI", null)
            }
          } else {
            result.error("SOUND_ERROR", "No sound URI available or context is null", null)
          }
        } catch (e: Exception) {
          result.error("SOUND_ERROR", "Failed to play alert sound: ${e.message}", null)
        }
      }
      "showAlert" -> {
        val args = call.arguments as? HashMap<String, String>
        if (args == null) {
          result.error("No args", "Args is a null object.", "")
        } else if (this.activity == null) {
          result.error("NO_ACTIVITY", "Activity is not available. Cannot show alert when app is backgrounded.", null)
        } else {
          val windowTitle = args["windowTitle"] ?: ""
          val text = args["text"] ?: ""
          val alertStyle = args["alertStyle"] ?: "ok"
          val cancelable = args["cancelable"] as Boolean? ?: true

          val dialog = AlertDialog.Builder(
            this.activity,
            getDialogStyle()
          ).setTitle(windowTitle).setMessage(text).apply {
            when (alertStyle) {
              "abortRetryIgnore" ->
                setPositiveButton(R.string.retry) { _, _ -> result.success("retry") }
                  .setNeutralButton(R.string.ignore) { _, _ -> result.success("ignore") }
                  .setNegativeButton(R.string.abort) { _, _ -> result.success("abort") }
              "cancelTryContinue" ->
                setPositiveButton(R.string.try_again) { _, _ -> result.success("try_again") }
                  .setNeutralButton(R.string.continue_button) { _, _ -> result.success("continue" ) }
                  .setNegativeButton(R.string.cancel) { _, _ -> result.success("cancel") }
              "okCancel" ->
                setPositiveButton(R.string.ok) { _, _ -> result.success("ok") }
                  .setNegativeButton(R.string.cancel) { _, _ -> result.success("cancel") }
              "retryCancel" ->
                setPositiveButton(R.string.retry) { _, _ -> result.success("retry") }
                  .setNegativeButton(R.string.cancel) { _, _ -> result.success("cancel") }
              "yesNo" ->
                setPositiveButton(R.string.yes) { _, _ -> result.success("yes") }
                  .setNegativeButton(R.string.no) { _, _ -> result.success("no") }
              "yesNoCancel" ->
                setPositiveButton(R.string.yes) { _, _ -> result.success("yes") }
                  .setNeutralButton(R.string.cancel) { _, _ -> result.success("cancel") }
                  .setNegativeButton(R.string.no) { _, _ -> result.success("no") }
              else -> setPositiveButton(R.string.ok) { _, _ -> result.success("ok") }
            }
          }.create()
          dialog.setCancelable(cancelable)
          dialog.setOnCancelListener {
              result.success("cancel")
          }
          dialog.show()
        }
      }
      "showCustomAlert" -> {
        val args = call.arguments as? HashMap<String, String>
        if (args == null) {
          result.error("No args", "Args is a null object.", "")
        } else if (this.activity == null) {
          result.error("NO_ACTIVITY", "Activity is not available. Cannot show alert when app is backgrounded.", null)
        } else {
          val windowTitle = args["windowTitle"] ?: ""
          val text = args["text"] ?: ""
          val positiveButtonTitle = args["positiveButtonTitle"] ?: ""
          val negativeButtonTitle = args["negativeButtonTitle"] ?: ""
          val neutralButtonTitle = args["neutralButtonTitle"] ?: ""
          val base64Icon = args["base64Icon"] ?: ""
          val cancelable = args["cancelable"] as Boolean? ?: true

          val builder = AlertDialog.Builder(
            this.activity,
            getDialogStyle()
          ).setTitle(windowTitle).setMessage(text)
          var buttonCount = 0
          if (positiveButtonTitle.isNotEmpty()) {
            builder.setPositiveButton(positiveButtonTitle) { _, _ -> result.success("positive_button") }
            buttonCount += 1
          }
          if (negativeButtonTitle.isNotEmpty()) {
            builder.setNegativeButton(negativeButtonTitle) { _, _ -> result.success("negative_button") }
            buttonCount += 1
          }
          if (negativeButtonTitle.isNotEmpty()) {
            builder.setNeutralButton(neutralButtonTitle) { _, _ -> result.success("neutral_button") }
            buttonCount += 1
          }
          if (buttonCount == 0) {
            builder.setPositiveButton("OK") { _, _ -> result.success("other") }
            buttonCount += 1
          }

          if (base64Icon.isNotEmpty()) {
            val decodedString = Base64.decode(base64Icon,Base64.DEFAULT)
            val decodedByte: Bitmap = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
            val icon: Drawable = BitmapDrawable(activity?.resources, decodedByte)
            builder.setIcon(icon)
          }

          val dialog = builder.create()
          dialog.setCancelable(cancelable)
          dialog.setOnCancelListener {
            result.success("cancel")
          }
          dialog.show()
        }
      }
      else -> result.notImplemented()
    }

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP_MR1)
  private fun getDialogStyle(): Int {
    if (this.context != null) {
      val nightModeFlags: Int = this.context!!.resources.configuration.uiMode and
              Configuration.UI_MODE_NIGHT_MASK
      when (nightModeFlags) {
        Configuration.UI_MODE_NIGHT_NO -> return android.R.style.Theme_DeviceDefault_Light_Dialog_Alert
      }
    }
    return android.R.style.Theme_DeviceDefault_Dialog_Alert
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_platform_alert")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }

  //region ActivityAware

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  //endregion
}
