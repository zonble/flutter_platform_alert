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

AlertButton stringToAlertButton(String string) {
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
