import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/src/icon_style.dart';

import 'alert_button.dart';
import 'alert_style.dart';
import 'icon_style.dart';

/// Helps to play platform alert sound and show platform alert dialogs.
class FlutterPlatformAlert {
  static const MethodChannel _channel = MethodChannel('flutter_platform_alert');

  /// Plays the system alert sound.
  ///
  /// Setting [iconStyle] could decide which sound, such as sounds for warnings,
  /// errors and so on,  woul be played on Windows.
  ///
  /// It makes an iPhone to virbate on iOS.
  static Future<void> playAlertSound(
      {IconStyle iconStyle = IconStyle.none}) async {
    final iconStyleString = iconStyleToString(iconStyle);
    await _channel.invokeMethod('playAlertSound', {
      'iconStyle': iconStyleString,
    });
  }

  /// Shows a platform dialog or alert.
  ///
  /// Just assign a [windowTitle] and [text], and it will shows the platform
  /// dialog/alert. Once a user click on one of the button on it, the method
  /// returns the name of the button.
  ///
  /// Please note that [iconStyle] is not implemented on mobile platforms like
  /// iOS and Android. On Windows, setting [iconStyle] also makes the system to
  /// play alert sounds and you don't need to call [playAlertSound] again.
  ///
  /// [preferMessageBoxOnWindows] represents if you want to use MessageBox API
  /// instead of TaskDialogIndirect on Windows. Actually TaskDialogIndirect is a
  /// newer API and looks much better than MessageBox.
  static Future<AlertButton> showAlert({
    required String windowTitle,
    required String text,
    AlertButtonStyle alertStyle = AlertButtonStyle.ok,
    IconStyle iconStyle = IconStyle.none,
    bool preferMessageBoxOnWindows = false,
  }) async {
    final alertStyleString = alertStyleToString(alertStyle);
    final iconStyleString = iconStyleToString(iconStyle);
    final result = await _channel.invokeMethod('showAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'alertStyle': alertStyleString,
      'iconStyle': iconStyleString,
      'preferMessageBox': preferMessageBoxOnWindows,
    });
    return stringToAlertButton(result);
  }
}
