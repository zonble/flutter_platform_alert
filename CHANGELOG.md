## 0.8.0

- Support Flutter 3.32.0.
- Handles barrier dismiss on Android.
  - A new option `cancelable` is added to the alert options.
  - By the default, the alert dialog is cancelable.
  - When a user taps outside the alert dialog, it will be dismissed and return "cancel".
- Updates the example app to use the latest Flutter version.

## 0.7.0

- Support Flutter 3.29.0
- Update iOS API.

## 0.6.0

- The plugin is not Swift Package Manager ready.

## 0.5.3

- Fix Android build for Flutter 3.24.0.

## 0.5.1

- Fix issues on Android.

## 0.5.0

- Breaking refactor by replacing FlutterPlatformAlertOption with PlatformAlertOptions.
- New customizations with IosAlertStyle and IosButtonStyle.
- Updates documentation and examples.

## 0.4.0

- Support Flutter 3.10.x.

## 0.3.0

- Support destructive button on macOS.

## 0.2.8

- Fixes a crash on iPadOS.

## 0.2.7

- Downgrade min SDK to API level 19 for Android.

## 0.2.6

- Allows adding icons to the native alert dialogs.

## 0.2.2

- Allows users to place the alert window to the center of the parent window or
  the center of the screen.
- Fixes the position of the alert window when the parent window is hidden or
  minimized.
- Activates the app when showing an alert window on macOS.

## 0.2.1

- Minor fixes.

## 0.2.0

- Implements alerts with custom buttons.

## 0.1.5

- Updates documentation and examples.

## 0.1.3

- Fixes issues on Windows.

## 0.1.2

- Tunes Android build settings.

## 0.1.1

- Fixes a typo and a potential crash.

## 0.1.0

- Initial release
