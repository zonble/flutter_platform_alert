import 'dart:async';

import 'package:flutter/services.dart';

enum FlutterPlatformAlerButton {
  abortButton,
  cancelButton,
  continueButton,
  ignoreButton,
  noButton,
  okButton,
  retryButton,
  tryAgainButton,
  yesButton,
}

enum AlertStyle {
  abortRetryIgnore,
  cancelTryContinue,
  ok,
  okCancel,
  retryCancel,
  yesNo,
  yesNoCancel,
}

String _alertStyleToString(AlertStyle style) {
  switch (style) {
    case AlertStyle.abortRetryIgnore:
      return 'abortRetryIgnore';
    case AlertStyle.cancelTryContinue:
      return 'cancelTryContinue';
    case AlertStyle.ok:
      return 'ok';
    case AlertStyle.okCancel:
      return 'okCancel';
    case AlertStyle.retryCancel:
      return 'retryCancel';
    case AlertStyle.yesNo:
      return 'yesNo';
    case AlertStyle.yesNoCancel:
      return 'yesNoCancel';
  }
}

enum IconStyle {
  none,
  exclamation,
  warning,
  information,
  asterisk,
  question,
  stop,
  error,
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

class FlutterPlatformAlert {
  static const MethodChannel _channel = MethodChannel('flutter_platform_alert');

  static Future<void> playAlertSound() async {
    await _channel.invokeMethod('playAlertSound');
  }

  static Future<String> showAlert({
    required String windowTitle,
    required String text,
    AlertStyle alertStyle = AlertStyle.ok,
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
    return result;
  }

// static Future<String?> get platformVersion async {
//   final String? version = await _channel.invokeMethod('getPlatformVersion');
//   return version;
// }
}
