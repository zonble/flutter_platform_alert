import 'package:flutter/services.dart';

import 'alert_button.dart';
import 'alert_style.dart';
import 'icon_style.dart';

/// Helps to play platform alert sound and show platform alert dialogs.
class FlutterPlatformAlert {
  static const MethodChannel _channel = MethodChannel('flutter_platform_alert');

  /// Plays the system alert sound.
  ///
  /// It makes an iPhone to virbate on iOS.
  static Future<void> playAlertSound() async {
    await _channel.invokeMethod('playAlertSound');
  }

  /// Shows a platform dialog or alert.
  ///
  /// Just assign a [windowTitle] and [text], and it will shows the platform
  /// dialog/alert. Once a user click on one of the button on it, the method
  /// returns the name of the button.
  ///
  /// Please note that [iconStyle] is not implemented on mobile platforms like
  /// iOS and Android.
  ///
  /// [preferMessageBoxOnWindows] represents if you want to use MessageBox API
  /// instead of   on Windows.
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
