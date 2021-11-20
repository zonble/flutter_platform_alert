# flutter_platform_alert

2021 © Weizhong Yang a.k.a zonble.

A simple plugin to present native alerts, including playing alert sounds and
showing alert dialogs. It uses following API to show play alert sound.

- iOS: [AudioService](https://developer.apple.com/documentation/audiotoolbox/1405248-audioservicesplaysystemsound)
- Android: [RingtoneManager](https://developer.android.com/reference/android/media/RingtoneManager)
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

To play platform alert sound.

```dart
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
await FlutterPlatformAlert.playAlertSound();
```

To show a platform alert dialog.

```dart
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
await FlutterPlatformAlert.playAlertSound();

final clickedButton = await FlutterPlatformAlert.showAlert(
    windowTitle: 'This ia title',
    text: 'This is body',
    alertStyle: AlertButtonStyle.yesNoCancel,
    iconStyle: IconStyle.information,
);
```

## Platform Alert Dialogs

### Alert Styles

You can specify the buttons listed in the alert dialog by passing `alertStyle`
argument. The package follows the API design on Windows (see the reference of
[MessageBox win32 API](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox)),
and it provides following styles:

- Abort, retry and ignore
- Cancel, try again and continue
- OK
- OK and cancel
- Retry and cancel
- Yes and no
- Yes, no, and cancel

### Icon Styles

The package also follow the API design of MessageBox on Windows to add icons to
the alert dialogs (see the link above). There are several different icons styles
but actually four:

- No icon
- Warning icon
- Information icon
- Question icon

Please note that icons are not available on iOS and Android.

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
