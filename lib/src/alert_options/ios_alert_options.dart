import '../styles/ios_alert_style.dart';
import '../styles/ios_button_style.dart';

/// Customise the windows alert.
class IosAlertOptions {
  IosAlertStyle alertStyle;

  /// Styles the positive button. Default is [IosButtonStyle.normal].
  IosButtonStyle? positiveButtonStyle;

  /// Styles the negative button. Default is [IosButtonStyle.normal].
  IosButtonStyle? negativeButtonStyle;

  /// Styles the neutral button. Default is [IosButtonStyle.normal].
  IosButtonStyle? neutralButtonStyle;

  /// Creates a new instance.
  IosAlertOptions({
    this.alertStyle = IosAlertStyle.alertDialog,
    this.positiveButtonStyle,
    this.negativeButtonStyle,
    this.neutralButtonStyle,
  }) {
    positiveButtonStyle ??= IosButtonStyle.normal;
    negativeButtonStyle ??= IosButtonStyle.normal;
    neutralButtonStyle ??= IosButtonStyle.normal;
  }

  /// Returns the options json.
  Map<String, Object> toJson() {
    return {
      'iosAlertStyle': alertStyle.name,
      'positiveButtonStyle': positiveButtonStyle!.name,
      'negativeButtonStyle': negativeButtonStyle!.name,
      'neutralButtonStyle': neutralButtonStyle!.name,
    };
  }
}
