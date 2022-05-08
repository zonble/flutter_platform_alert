/// Represents the button that a user clicks on.
enum AlertButton {
  /// The "abort" button.
  abortButton,

  /// The "cancel" button.
  cancelButton,

  /// The "continue" button.
  continueButton,

  /// The "ignore" button.
  ignoreButton,

  /// The "no" button.
  noButton,

  /// The "ok" button.
  okButton,

  /// The "retry" button.
  retryButton,

  /// The "try again" button.
  tryAgainButton,

  /// The "yes" button.
  yesButton,

  /// Other unknown button.
  other,
}

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

enum CustomButton {
  positiveButton,
  negativeButton,
  neutralButton,
  other,
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
