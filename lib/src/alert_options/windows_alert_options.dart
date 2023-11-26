/// Customise the windows alert.
class WindowsAlertOptions {
  /// [preferMessageBox] represents if you want to use MessageBox API
  /// instead of
  /// [TaskDialogIndirect](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect)
  /// on Windows when calling [FlutterPlatformAlert.showAlert].
  ///
  /// When [preferMessageBox] is false, you can also assign an
  /// [additionalWindowTitle]. Actually
  /// [TaskDialogIndirect](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect)
  /// is a newer API and looks much better than MessageBox.
  late bool preferMessageBox = false;

  /// [showAsLinks] option applies
  /// [TDF_USE_COMMAND_LINKS](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-taskdialogconfig)
  /// flag on Windows while calling
  /// [TaskDialogIndirect](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect)
  /// API. The option is only available when calling
  /// [FlutterPlatformAlert.showCustomAlert] but it does not work on
  /// [FlutterPlatformAlert.showAlert].
  late bool showAsLinks = false;

  /// An additional window title.
  /// Only works when [preferMessageBox] is false
  final String additionalWindowTitle;

  /// Creates a new instance.
  WindowsAlertOptions({
    this.preferMessageBox = false,
    this.showAsLinks = false,
    this.additionalWindowTitle = '',
  });

  /// Returns the options json
  Map<String, Object> toJson() {
    return {
      'preferMessageBox': preferMessageBox,
      'showAsLinksOnWindows': showAsLinks,
      'additionalWindowTitle': additionalWindowTitle,
    };
  }
}
