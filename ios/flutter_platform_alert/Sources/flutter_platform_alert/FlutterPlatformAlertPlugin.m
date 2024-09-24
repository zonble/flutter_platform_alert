#import "FlutterPlatformAlertPlugin.h"
#if __has_include(<flutter_platform_alert/flutter_platform_alert-Swift.h>)
#import <flutter_platform_alert/flutter_platform_alert-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_platform_alert-Swift.h"
#endif

@implementation FlutterPlatformAlertPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPlatformAlertPlugin registerWithRegistrar:registrar];
}
@end
