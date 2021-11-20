import 'dart:async';

import 'package:flutter/services.dart';

/// Represents the button that a user clicks on.
enum AlertButton {
  /// The "abort" buitton.
  abortButton,

  /// The "cancel" buitton.
  cancelButton,

  /// The "continue" buitton.
  continueButton,

  /// The "ignore" buitton.
  ignoreButton,

  /// The "no" buitton.
  noButton,

  /// The "ok" buitton.
  okButton,

  /// The "retry" buitton.
  retryButton,

  /// The "try again" buitton.
  tryAgainButton,

  /// The "yes" buitton.
  yesButton,

  /// Other unknown button.
  other,
}

AlertButton _stringToAlertButton(String string) {
  switch (string) {
    case "abort":
      return AlertButton.abortButton;
    case "cancel":
      return AlertButton.cancelButton;
    case "continue":
      return AlertButton.continueButton;
    case "ignore":
      return AlertButton.ignoreButton;
    case "no":
      return AlertButton.noButton;
    case "ok":
      return AlertButton.okButton;
    case "retry":
      return AlertButton.retryButton;
    case "try_again":
      return AlertButton.tryAgainButton;
    case "yes":
      return AlertButton.yesButton;
    default:
      break;
  }
  return AlertButton.other;
}

/// Represents the buttons in the dialog/alert.
enum AlertButtonStyle {
  /// Abort, retry, and ignore.
  abortRetryIgnore,

  /// Cancel, try again and continue.
  cancelTryContinue,

  /// Only OK in the dialog.
  ok,

  /// OK and cancel.
  okCancel,

  /// Retry and cancel.
  retryCancel,

  /// Yes and no.
  yesNo,

  /// Yes, no and cancel.
  yesNoCancel,
}

String _alertStyleToString(AlertButtonStyle style) {
  switch (style) {
    case AlertButtonStyle.abortRetryIgnore:
      return 'abortRetryIgnore';
    case AlertButtonStyle.cancelTryContinue:
      return 'cancelTryContinue';
    case AlertButtonStyle.ok:
      return 'ok';
    case AlertButtonStyle.okCancel:
      return 'okCancel';
    case AlertButtonStyle.retryCancel:
      return 'retryCancel';
    case AlertButtonStyle.yesNo:
      return 'yesNo';
    case AlertButtonStyle.yesNoCancel:
      return 'yesNoCancel';
  }
}

/// Represents the icon that appears in the dialog/alert.
enum IconStyle {
  /// No icon.
  none,

  /// Represents showing a icon for errors.
  ///
  /// - MB_ICONEXCLAMATION on Windows.
  /// - GTK_MESSAGE_WARNING on Linux.
  exclamation,

  /// Represents showing a icon for errors.
  ///
  /// - MB_ICONWARNING on Windows.
  /// - GTK_MESSAGE_WARNING on Linux.
  warning,

  /// Represents showing a icon with a letter "i".
  ///
  /// - MB_ICONINFORMATION on Windows.
  /// - GTK_MESSAGE_INFO on Linux.
  information,

  /// Represents showing a icon with a letter "i".
  ///
  /// - MB_ICONASTERISK on Windows.
  /// - GTK_MESSAGE_INFO on Linux.
  asterisk,

  /// Represents showing a question icon.
  ///
  /// - MB_ICONQUESTION on Windows.
  /// - GTK_MESSAGE_QUESTION on Linux.
  question,

  /// Represents showing a stop or error icon.
  ///
  /// - MB_ICONSTOP on Windows.
  /// - GTK_MESSAGE_ERROR on Linux.
  stop,

  /// Represents showing a stop or error icon.
  ///
  /// - MB_ICONERROR on Windows
  /// - GTK_MESSAGE_ERROR on Linux.
  error,

  /// Represents showing a stop or error icon.
  /// - MB_ICONHAND on Windows.
  /// - GTK_MESSAGE_ERROR on Linux.
  hand,
}

String _iconStyleToString(IconStyle style) {
  switch (style) {
    case IconStyle.none:
      return 'none';
    case IconStyle.exclamation:
      return 'exclamation';
    case IconStyle.warning:
      return 'warning';
    case IconStyle.information:
      return 'information';
    case IconStyle.asterisk:
      return 'asterisk';
    case IconStyle.question:
      return 'question';
    case IconStyle.stop:
      return 'stop';
    case IconStyle.error:
      return 'error';
    case IconStyle.hand:
      return 'hand';
  }
}

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
  static Future<AlertButton> showAlert({
    required String windowTitle,
    required String text,
    AlertButtonStyle alertStyle = AlertButtonStyle.ok,
    IconStyle iconStyle = IconStyle.none,
  }) async {
    final alertStyleString = _alertStyleToString(alertStyle);
    final iconStyleString = _iconStyleToString(iconStyle);
    final result = await _channel.invokeMethod('showAlert', {
      'windowTitle': windowTitle,
      'text': text,
      'alertStyle': alertStyleString,
      'iconStyleString': iconStyleString,
    });
    return _stringToAlertButton(result);
  }
}
