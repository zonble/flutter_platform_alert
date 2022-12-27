package net.zonble.flutter_platform_alert

import android.app.Activity
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.media.RingtoneManager
import android.os.Build
import android.util.Base64
import androidx.annotation.NonNull
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
        val notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val ringTone =
          RingtoneManager.getRingtone(this.context, notification)
        ringTone.play()
        result.success(null)
      }
      "showAlert" -> {
        val args = call.arguments as? HashMap<String, String>
        if (args == null) {
          result.error("No args", "Args is a null object.", "")
        } else {
          val windowTitle = args.getOrDefault("windowTitle", "")
          val text = args.getOrDefault("text", "")
          val alertStyle = args.getOrDefault("alertStyle", "ok")
          val useMaterialBuilder = args.getOrDefault("useMaterialBuilder", false)

          val context = this.activity
          if (context == null) {
            print("no context")
          } else {
            val adapter: IDialogBuilderAdapter = if (useMaterialBuilder == true) {
              MaterialAlertDialogBuilderAdapter(context)
            } else {
              AlertDialogBuilderAdapter(context)
            }

            adapter.setTitle(windowTitle).setMessage(text).apply {
              when (alertStyle) {
                "abortRetryIgnore" ->
                  setPositiveButton(R.string.retry) { _, _ -> result.success("retry") }
                    .setNeutralButton(R.string.ignore) { _, _ -> result.success("ignore") }
                    .setNegativeButton(R.string.abort) { _, _ -> result.success("abort") }
                "cancelTryContinue" ->
                  setPositiveButton(R.string.try_again) { _, _ -> result.success("try_again") }
                    .setNeutralButton(R.string.continue_button) { _, _ -> result.success("continue") }
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
            }.createAndShow()
          }
        }
      }
      "showCustomAlert" -> {
        val args = call.arguments as? HashMap<String, String>
        if (args == null) {
          result.error("No args", "Args is a null object.", "")
        } else {
          val windowTitle = args.getOrDefault("windowTitle", "")
          val text = args.getOrDefault("text", "")
          val positiveButtonTitle = args.getOrDefault("positiveButtonTitle", "")
          val negativeButtonTitle = args.getOrDefault("negativeButtonTitle", "")
          val neutralButtonTitle = args.getOrDefault("neutralButtonTitle", "")
          val base64Icon = args.getOrDefault("base64Icon", "")
          val useMaterialBuilder = args.getOrDefault("useMaterialBuilder", false)

          val context = this.activity
          if (context == null) {
            print("no context")
          } else {
            val adapter: IDialogBuilderAdapter = if (useMaterialBuilder == true) {
              MaterialAlertDialogBuilderAdapter(context)
            } else {
              AlertDialogBuilderAdapter(context)
            }
            adapter.setTitle(windowTitle).setMessage(text)

            var buttonCount = 0
            if (positiveButtonTitle.isNotEmpty()) {
              adapter.setPositiveButton(positiveButtonTitle) { _, _ -> result.success("positive_button") }
              buttonCount += 1
            }
            if (negativeButtonTitle.isNotEmpty()) {
              adapter.setNegativeButton(negativeButtonTitle) { _, _ -> result.success("negative_button") }
              buttonCount += 1
            }
            if (negativeButtonTitle.isNotEmpty()) {
              adapter.setNeutralButton(neutralButtonTitle) { _, _ -> result.success("neutral_button") }
              buttonCount += 1
            }
            if (buttonCount == 0) {
              adapter.setPositiveButton("OK") { _, _ -> result.success("other") }
              buttonCount += 1
            }

            if (base64Icon.isNotEmpty()) {
              val decodedString = Base64.decode(base64Icon, Base64.DEFAULT)
              val decodedByte: Bitmap =
                BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
              val icon: Drawable = BitmapDrawable(activity?.resources, decodedByte)
              adapter.setIcon(icon)
            }

            adapter.createAndShow()
          }
        }
      }
      else -> result.notImplemented()
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
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

  //endregion
}
