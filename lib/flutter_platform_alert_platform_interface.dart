import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_platform_alert_method_channel.dart';

abstract class FlutterPlatformAlertPlatform extends PlatformInterface {
  /// Constructs a FlutterPlatformAlertPlatform.
  FlutterPlatformAlertPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPlatformAlertPlatform _instance = MethodChannelFlutterPlatformAlert();

  /// The default instance of [FlutterPlatformAlertPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPlatformAlert].
  static FlutterPlatformAlertPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPlatformAlertPlatform] when
  /// they register themselves.
  static set instance(FlutterPlatformAlertPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
