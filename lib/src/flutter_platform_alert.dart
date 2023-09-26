import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'alert_options/platform_alert_options.dart';
import 'helpers.dart';
import 'styles/icon_style.dart';

import 'alert_button.dart';
import 'styles/alert_style.dart';
import 'window_position.dart';
import 'package:path/path.dart' as path;

/// Helps to play platform alert sound and show platform alert dialogs.
class FlutterPlatformAlert {
  FlutterPlatformAlert._();

  static const MethodChannel _channel = MethodChannel('flutter_platform_alert');

  /// Plays the system alert sound.
  ///
  /// Setting [iconStyle] could decide which sound, such as sounds for warnings,
  /// errors and so on, would be played on Windows.
  ///
  /// It makes an iPhone to vibrate on iOS.
  static Future<void> playAlertSound(
      {IconStyle iconStyle = IconStyle.none}) async {
    final iconStyleString = iconStyle.name;
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
  /// Using the API is much like calling
  /// [MessageBox](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox)
  /// API on Windows. You cannot change the title of the buttons on the dialog
  /// window, but to choose a set of buttons by assigning [alertStyle]. If you
  /// want to customize the buttons, you can use
  /// [FlutterPlatformAlert.showCustomAlert] instead.
  ///
  /// Please note that [iconStyle] is not implemented on mobile platforms like
  /// iOS and Android. On Windows, setting [iconStyle] also makes the system to
  /// play alert sounds and you don't need to call [playAlertSound] again.
  ///
  /// On windows, you can pick one of two implementation. One is using
  /// MessageBox while another is using
  /// [TaskDialogIndirect](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect).
  /// You can do this by assigning the [options] parameter. See more details by
  /// visiting [FlutterPlatformAlertOption].
  static Future<AlertButton> showAlert({
    required String windowTitle,
    required String text,
    AlertButtonStyle alertStyle = AlertButtonStyle.ok,
    IconStyle iconStyle = IconStyle.none,
    PlatformAlertOptions? options,
    AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
  }) async {
    options ??= PlatformAlertOptions();
    final result = await _channel.invokeMethod('showAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'alertStyle': alertStyle.stringValue,
      'iconStyle': iconStyle.stringValue,
      'position': positionToInt(windowPosition),
      ...options.toJson(),
    });
    return AlertButtonHelper.fromString(result);
  }

  /// Shows a platform alert dialog with custom button titles.
  ///
  /// Using the API is much like calling
  /// [AlertDialog](https://developer.android.com/reference/android/app/AlertDialog)
  /// on Android,  you can assign up to 3 buttons in the alert dialog and
  /// customize the titles of the buttons. [positiveButtonTitle] is the title of
  /// the positive button like for "OK" or "Yes", [negativeButtonTitle] is the
  /// title for the negative button like "Cancel" or "No", while
  /// [neutralButtonTitle] is for other buttons. Once you leave the title of the
  /// button empty, the button will not be shown.
  ///
  /// You can also specify an icon by assigning the [iconPath] parameter. The
  /// parameter works on Android, Windows, macOS and Linux (iOS is not
  /// supported). The path should be as the path of an asset in your Flutter
  /// app, for example, if you can create an image widget as
  ///
  /// ``` dart
  /// Image.asset('images/tray_icon_original.png');
  /// ```
  ///
  /// You should just pass 'images/tray_icon_original.png' to the [iconPath]
  /// parameter.
  ///
  /// Please note that we only support ICO files on Windows.
  ///
  /// On Windows, the API always call
  /// [TaskDialogIndirect](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect)
  /// even you set the [FlutterPlatformAlertOption.preferMessageBoxOnWindows]
  /// property in the [options] parameter to true.
  ///
  static Future<CustomButton> showCustomAlert({
    required String windowTitle,
    required String text,
    IconStyle iconStyle = IconStyle.none,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    String? neutralButtonTitle,
    PlatformAlertOptions? options,
    AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
    String iconPath = '',
  }) async {
    positiveButtonTitle ??= '';
    negativeButtonTitle ??= '';
    neutralButtonTitle ??= '';
    options ??= PlatformAlertOptions();

    final base64Icon = await () async {
      if (iconPath.isEmpty) return '';

      final imageData = await rootBundle.load(iconPath);
      String base64Icon = base64Encode(imageData.buffer.asUint8List());
      return base64Icon;
    }();

    var context = path.Context(style: path.Style.platform);
    final exactIconPath = iconPath.isNotEmpty
        ? context.joinAll([
            path.dirname(Platform.resolvedExecutable),
            'data/flutter_assets',
            iconPath,
          ])
        : '';

    final result = await _channel.invokeMethod('showCustomAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'iconStyle': iconStyle.name,
      'positiveButtonTitle': positiveButtonTitle,
      'negativeButtonTitle': negativeButtonTitle,
      'neutralButtonTitle': neutralButtonTitle,
      'position': positionToInt(windowPosition),
      'iconPath': exactIconPath,
      'base64Icon': base64Icon,
      ...options.toJson(),
    });
    return CustomButtonHelper.fromString(result);
  }
}
