import 'dart:io';

import 'ios_alert_options.dart';
import 'macos_alert_options.dart';
import 'windows_alert_options.dart';

/// Additional options for [FlutterPlatformAlert].
class PlatformAlertOptions {
  final IosAlertOptions? ios;
  final MacosAlertOptions? macos;
  final WindowsAlertOptions? windows;

  /// Creates a new instance.
  PlatformAlertOptions({
    this.ios,
    this.macos,
    this.windows,
  });

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
    return {};
  }
}
