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

/// Represents the buttons in [FlutterPlatformAlert.showCustomAlert].
enum CustomButton {
  /// The positive button.
  positiveButton,

  /// The negative button.
  negativeButton,

  /// The neutral button.
  neutralButton,

  /// Other unknown button.
  other,
}
