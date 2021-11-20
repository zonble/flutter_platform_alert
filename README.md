# flutter_platform_alert

2021 © Weizhong Yang a.k.a zonble.

A simple plugin to present native alerts, including playing alert sounds and
showing alert dialogs. It uses following API to show play alert sound.

- iOS: [AudioService](https://developer.apple.com/documentation/audiotoolbox/1405248-audioservicesplaysystemsound)
- Android:
- Windows: [MessageBeep](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebeep)
- macOS: [NSSound](https://developer.apple.com/documentation/appkit/nssound/2903487-beep)
- Linux: [gtk_widget_error_bell](https://docs.gtk.org/gtk3/method.Widget.error_bell.html)

It uses following API to show alert dialogs.

- iOS: [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller) (It requires iOS 8)
- Android: [AlertDialog](https://developer.android.com/reference/android/app/AlertDialog)
- Windows: [MessageBox](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox)
- macOS: [NSAlert](https://developer.apple.com/documentation/appkit/nsalert)
- Linux: [GtkMessageDialog](https://docs.gtk.org/gtk3/class.MessageDialog.html)

## Getting Started

- Add the dependency to your pubspec.yaml file by `flutter pub add flutter_platform_alert`.
- Run `flutter pub get`.

## Localization

Since the plugin calls native API, if you want to localize buttons like "OK",
"Cancel" and so on on Platforms like iOS, macOS and Linux, you have to do some
works in your app.

- To localize the button titles on iOS and macOS, add "Localizable.strings" or
  "Localizable.stringsdict" files in your Xcode project. Visit Apple's official
  page for [localization](https://developer.apple.com/localization) for further
  information.
- On Linux, we use [gettext](https://www.gnu.org/software/gettext/) to localize
  apps. Please update the PO files in your projects once you integrate the
  plugin.
