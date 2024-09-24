import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_platform_alert_platform_interface.dart';

/// An implementation of [FlutterPlatformAlertPlatform] that uses method channels.
class MethodChannelFlutterPlatformAlert extends FlutterPlatformAlertPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_platform_alert');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
