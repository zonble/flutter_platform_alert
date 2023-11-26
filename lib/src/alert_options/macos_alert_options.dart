/// Customise the macos alert.
class MacosAlertOptions {
  /// Styles the negative button with a red label that represents to change or delete something.
  bool isNegativeActionDestructive;

  /// Creates a new instance.
  MacosAlertOptions({
    this.isNegativeActionDestructive = false,
  });

  /// Returns the options json
  Map<String, Object> toJson() {
    return {
      'isNegativeActionDestructive': isNegativeActionDestructive,
    };
  }
}
