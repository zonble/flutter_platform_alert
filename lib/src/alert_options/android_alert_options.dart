/// Represents Android-specific options for an alert dialog.
class AndroidAlertOptions {
  /// Determines whether the alert dialog is cancelable.
  ///
  /// If set to `true` (the default), the dialog can be dismissed by tapping
  /// outside of the dialog or by pressing the back button. If set to `false`,
  /// the dialog can only be dismissed by pressing one of its buttons.
  bool? cancelable;

  /// Creates an instance of [AndroidAlertOptions].
  ///
  /// [cancelable] determines if the dialog can be dismissed by tapping outside
  /// or by pressing the back button. Defaults to `true` if not specified.
  AndroidAlertOptions({this.cancelable});

  /// Converts the [AndroidAlertOptions] to a JSON-like [Map] representation.
  Map<String, Object> toJson() => {'cancelable': cancelable ?? true};
}
