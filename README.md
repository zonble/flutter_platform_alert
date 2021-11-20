# flutter_platform_alert

2021 Weizhong Yang a.k.a zonble.

A simple plugin to present native alerts, including playing alert sounds and
showing alert dialogs.

It uses following API to show play alert sound.

- iOS: [AudioService](https://developer.apple.com/documentation/audiotoolbox/1405248-audioservicesplaysystemsound)
- Android:
- Windows: [MessageBeep](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebeep)
- macOS: [NSSound](https://developer.apple.com/documentation/appkit/nssound/2903487-beep)
- Linux: [gtk_widget_error_bell](https://docs.gtk.org/gtk3/method.Widget.error_bell.html)

It uses following API to show alert dialogs.

- iOS: [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
- Android: [AlertDialog](https://developer.android.com/reference/android/app/AlertDialog)
- Windows: [MessageBox](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox)
- macOS: [NSAlert](https://developer.apple.com/documentation/appkit/nsalert)
- Linux: [GtkMessageDialog](https://docs.gtk.org/gtk3/class.MessageDialog.html)

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
