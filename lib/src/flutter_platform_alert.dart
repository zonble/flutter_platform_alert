import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'icon_style.dart';

import 'alert_button.dart';
import 'alert_style.dart';
import 'window_position.dart';
import 'package:path/path.dart' as path;

int _positionToInt(AlertWindowPosition position) =>
    position == AlertWindowPosition.screenCenter ? 1 : 0;

/// Additional options for FlutterPlatformAlert.
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

  /// [showAsLinksOnWindows] option applies TDF_USE_COMMAND_LINKS flag on
  /// Windows while calling TaskDialogIndirect API. The option is only available
  /// when calling [FlutterPlatformAlert.showCustomAlert] but it does not work
  /// on [FlutterPlatformAlert.showAlert].
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
  /// errors and so on, would be played on Windows.
  ///
  /// It makes an iPhone to vibrate on iOS.
  static Future<void> playAlertSound(
      {IconStyle iconStyle = IconStyle.none}) async {
    final iconStyleString = iconStyle.stringValue;
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
    final alertStyleString = alertStyle.stringValue;
    final iconStyleString = iconStyle.stringValue;
    final result = await _channel.invokeMethod('showAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'alertStyle': alertStyleString,
      'iconStyle': iconStyleString,
      'preferMessageBox': options?.preferMessageBoxOnWindows ?? false,
      'additionalWindowTitle': options?.additionalWindowTitleOnWindows ?? '',
      'position': _positionToInt(windowPosition),
    });
    return AlertButtonHelper.fromString(result);
  }

  /// Shows a platform alert dialog with custom button titles.
  ///
  /// You can assign up to 3 buttons in the alert dialog. The method follows the
  /// convention on Android. [positiveButtonTitle] is the title of the positive
  /// button like for "OK" or "Yes",  [negativeButtonTitle] is the title for the
  /// negative button like "Cancel" or "No", while [neutralButtonTitle] is for
  /// other buttons.
  ///
  /// You can also specify an icon by assigning the [iconPath] parameter. The
  /// parameter works on Windows, macOS and Linux. The path should be as the
  /// path of an asset in your Flutter app, for example, if you can create an
  /// image widget as
  ///
  /// ``` dart
  /// Image.asset('images/tray_icon_original.png');
  /// ```
  ///
  /// You should just pass 'images/tray_icon_original.png' to the [iconPath]
  /// parameter.
  ///
  /// Please note that we only support ICO files on Windows.
  static Future<CustomButton> showCustomAlert({
    required String windowTitle,
    required String text,
    IconStyle iconStyle = IconStyle.none,
    String? positiveButtonTitle = '',
    String? negativeButtonTitle = '',
    String? neutralButtonTitle = '',
    FlutterPlatformAlertOption? options,
    AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
    String? iconPath = '',
  }) async {
    final iconStyleString = iconStyle.stringValue;

    final base64Icon = await () async {
      if (iconPath == null) return '';
      if (iconPath.isEmpty) return '';

      final imageData = await rootBundle.load(iconPath);
      String base64Icon = base64Encode(imageData.buffer.asUint8List());
      return base64Icon;
    }();

    var context = path.Context(style: path.Style.platform);
    final exactIconPath = iconPath != null && iconPath.isNotEmpty
        ? context.joinAll([
            path.dirname(Platform.resolvedExecutable),
            'data/flutter_assets',
            iconPath,
          ])
        : '';

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
      'iconPath': exactIconPath,
      'base64Icon': base64Icon,
    });
    return CustomButtonHelper.fromString(result);
  }
}
