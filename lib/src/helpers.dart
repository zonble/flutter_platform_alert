import 'alert_button.dart';
import 'styles/alert_style.dart';
import 'styles/icon_style.dart';
import 'window_position.dart';

class AlertButtonHelper {
  static AlertButton fromString(String string) {
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
}

class CustomButtonHelper {
  static CustomButton fromString(String string) {
    switch (string) {
      case "positive_button":
        return CustomButton.positiveButton;
      case "negative_button":
        return CustomButton.negativeButton;
      case "neutral_button":
        return CustomButton.neutralButton;
      default:
        break;
    }
    return CustomButton.other;
  }
}

extension AlertButtonStyleToString on AlertButtonStyle {
  String get stringValue {
    switch (this) {
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
}

extension IconStyleToString on IconStyle {
  String get stringValue {
    switch (this) {
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
}

int positionToInt(AlertWindowPosition position) =>
    position == AlertWindowPosition.screenCenter ? 1 : 0;
