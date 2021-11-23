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

  /// Shows a platform alert dialog.
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
  /// instead of TaskDialogIndirect on Windows. When [preferMessageBoxOnWindows]
  /// is true, you can also assign an [additionalWindowTitleOnWindows]. Actually
  /// TaskDialogIndirect is a newer API and looks much better than MessageBox.
  static Future<AlertButton> showAlert({
    required String windowTitle,
    required String text,
    AlertButtonStyle alertStyle = AlertButtonStyle.ok,
    IconStyle iconStyle = IconStyle.none,
    bool preferMessageBoxOnWindows = false,
    String? additionalWindowTitleOnWindows,
  }) async {
    final alertStyleString = alertStyleToString(alertStyle);
    final iconStyleString = iconStyleToString(iconStyle);
    final result = await _channel.invokeMethod('showAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'alertStyle': alertStyleString,
      'iconStyle': iconStyleString,
      'preferMessageBox': preferMessageBoxOnWindows,
      'additionalWindowTitle': additionalWindowTitleOnWindows ?? '',
    });
    return stringToAlertButton(result);
  }

  /// Shows a platform alert dialog with custom button titles.
  ///
  /// You can assign up to 3 buttons in the alert dialog. The method follows the
  /// convention on Android. [positiveButtonTitle] is the title of the positive
  /// button like for "OK" or "Yes",  [negativeButtonTitle] is the title for the
  /// negative button like "Cancel" or "No", while [neutralButtonTitle] is for
  /// other buttons.
  ///
  /// [showAsLinksOnWindows] option applies TDF_USE_COMMAND_LINKS flag on
  /// Windows while calling TaskDialogIndirect API.
  /// [additionalWindowTitleOnWindows] is also for TaskDialogIndirect on
  /// Windows. The method only uses TaskDialogIndirect on Windows since
  /// MessageBox does not support custom button titles.
  static Future<CustomButton> showCustomAlert({
    required String windowTitle,
    required String text,
    IconStyle iconStyle = IconStyle.none,
    String? positiveButtonTitle = '',
    String? negativeButtonTitle = '',
    String? neutralButtonTitle = '',
    bool showAsLinksOnWindows = false,
    String? additionalWindowTitleOnWindows = '',
  }) async {
    final iconStyleString = iconStyleToString(iconStyle);
    final result = await _channel.invokeMethod('showCustomAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'additionalWindowTitle': additionalWindowTitleOnWindows ?? '',
      'iconStyle': iconStyleString,
      'positiveButtonTitle': positiveButtonTitle ?? '',
      'negativeButtonTitle': negativeButtonTitle ?? '',
      'neutralButtonTitle': neutralButtonTitle ?? '',
      'showAsLinksOnWindows': showAsLinksOnWindows,
    });
    return stringToCustomButton(result);
  }
}
