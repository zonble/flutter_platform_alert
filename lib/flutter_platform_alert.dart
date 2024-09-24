/// A simple plugin to present native alerts, including playing alert sounds and
/// showing alert dialogs.
///
/// It uses following API to show play alert sound.
///
/// - iOS: [AudioService](https://developer.apple.com/documentation/audiotoolbox/1405248-audioservicesplaysystemsound)
/// - Android: [RingtoneManager](https://developer.android.com/reference/android/media/RingtoneManager)
/// - Windows: [MessageBeep](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebeep)
/// - macOS: [NSSound](https://developer.apple.com/documentation/appkit/nssound/2903487-beep)
/// - Linux: [gtk_widget_error_bell](https://docs.gtk.org/gtk3/method.Widget.error_bell.html)
///
/// It uses following API to show alert dialogs.
///
/// - iOS: [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller) (It requires iOS 8)
/// - Android: [AlertDialog](https://developer.android.com/reference/android/app/AlertDialog)
/// - Windows: [MessageBox](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox) and
///   [TaskDialogIndirect](https://docs.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect)
/// - macOS: [NSAlert](https://developer.apple.com/documentation/appkit/nsalert)
/// - Linux: [GtkMessageDialog](https://docs.gtk.org/gtk3/class.MessageDialog.html)
library flutter_platform_alert;

export 'src/alert_options/ios_alert_options.dart';
export 'src/alert_options/macos_alert_options.dart';
export 'src/alert_options/platform_alert_options.dart';
export 'src/alert_options/windows_alert_options.dart';
export 'src/styles/alert_style.dart';
export 'src/styles/icon_style.dart';
export 'src/styles/ios_alert_style.dart';
export 'src/styles/ios_button_style.dart';
export 'src/alert_button.dart';
export 'src/flutter_platform_alert.dart';
export 'src/window_position.dart';
