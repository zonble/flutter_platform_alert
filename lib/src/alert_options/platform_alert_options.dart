import 'dart:io';

import 'android_alert_options.dart';
import 'ios_alert_options.dart';
import 'macos_alert_options.dart';
import 'windows_alert_options.dart';

/// Additional options for [FlutterPlatformAlert].
class PlatformAlertOptions {
  /// iOS-specific alert options.
  /// See [IosAlertOptions] for more details.
  final IosAlertOptions? ios;

  /// macOS-specific alert options.
  /// See [MacosAlertOptions] for more details.
  final MacosAlertOptions? macos;

  /// Windows-specific alert options.
  /// See [WindowsAlertOptions] for more details.
  final WindowsAlertOptions? windows;

  /// Android-specific alert options.
  /// See [AndroidAlertOptions] for more details.
  final AndroidAlertOptions? android;

  /// Creates a new instance.
  PlatformAlertOptions({this.ios, this.macos, this.windows, this.android});

  /// Returns the platform specific options json
  Map<String, Object> toJson() {
    if (Platform.isIOS) {
      return (ios ?? IosAlertOptions()).toJson();
    }
    if (Platform.isMacOS) {
      return (macos ?? MacosAlertOptions()).toJson();
    }
    if (Platform.isWindows) {
      return (windows ?? WindowsAlertOptions()).toJson();
    }
    if (Platform.isAndroid) {
      return (android ?? AndroidAlertOptions()).toJson();
    }
    return {};
  }
}
