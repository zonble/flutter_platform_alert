import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/src/icon_style.dart';

import 'alert_button.dart';
import 'alert_style.dart';
import 'icon_style.dart';
import 'window_position.dart';

int _positionToInt(AlertWindowPosition position) {
  if (position == AlertWindowPosition.screenCenter) {
    return 1;
  }
  return 0;
}

/// AAdditional options for FlutterPlatformAlert.
class FlutterPlatformAlertOption {
  /// [preferMessageBoxOnWindows] represents if you want to use MessageBox API
  /// instead of TaskDialogIndirect on Windows when calling
  /// [FlutterPlatformAlert.showAlert].
  ///
  /// The option only works on Windows.
  ///
  /// When [preferMessageBoxOnWindows] is false, you can also assign an
  /// [additionalWindowTitleOnWindows]. Actually TaskDialogIndirect is a newer
  /// API and looks much better than MessageBox.
  bool preferMessageBoxOnWindows = false;

  /// [showAsLinksOnWindows] option applies TDF_USE_COMMAND_LINKS flag on Windows
  /// while calling TaskDialogIndirect API. The option is only available when
  /// calling [FlutterPlatformAlert.showCustomAlert] but it does not work on
  /// [FlutterPlatformAlert.showAlert].
  ///
  /// The option only works on Windows.
  bool showAsLinksOnWindows = false;

  /// An additional window title.
  ///
  /// The option only works on Windows.
  String? additionalWindowTitleOnWindows;

  /// Creates a new instance.
  FlutterPlatformAlertOption({
    this.preferMessageBoxOnWindows = false,
    this.showAsLinksOnWindows = false,
    this.additionalWindowTitleOnWindows,
  });
}

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
  static Future<AlertButton> showAlert({
    required String windowTitle,
    required String text,
    AlertButtonStyle alertStyle = AlertButtonStyle.ok,
    IconStyle iconStyle = IconStyle.none,
    FlutterPlatformAlertOption? options,
    AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
  }) async {
    final alertStyleString = alertStyleToString(alertStyle);
    final iconStyleString = iconStyleToString(iconStyle);
    final result = await _channel.invokeMethod('showAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'alertStyle': alertStyleString,
      'iconStyle': iconStyleString,
      'preferMessageBox': options?.preferMessageBoxOnWindows ?? false,
      'additionalWindowTitle': options?.additionalWindowTitleOnWindows ?? '',
      'position': _positionToInt(windowPosition),
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
  static Future<CustomButton> showCustomAlert({
    required String windowTitle,
    required String text,
    IconStyle iconStyle = IconStyle.none,
    String? positiveButtonTitle = '',
    String? negativeButtonTitle = '',
    String? neutralButtonTitle = '',
    FlutterPlatformAlertOption? options,
    AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
  }) async {
    final iconStyleString = iconStyleToString(iconStyle);
    final result = await _channel.invokeMethod('showCustomAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'iconStyle': iconStyleString,
      'positiveButtonTitle': positiveButtonTitle ?? '',
      'negativeButtonTitle': negativeButtonTitle ?? '',
      'neutralButtonTitle': neutralButtonTitle ?? '',
      'additionalWindowTitle': options?.additionalWindowTitleOnWindows ?? '',
      'showAsLinksOnWindows': options?.showAsLinksOnWindows ?? false,
      'position': _positionToInt(windowPosition),
    });
    return stringToCustomButton(result);
  }
}
