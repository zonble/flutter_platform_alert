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
