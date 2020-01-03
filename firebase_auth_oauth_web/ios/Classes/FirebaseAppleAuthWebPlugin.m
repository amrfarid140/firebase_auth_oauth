#import "FirebaseAppleAuthWebPlugin.h"
#if __has_include(<firebase_apple_auth_web/firebase_apple_auth_web-Swift.h>)
#import <firebase_apple_auth_web/firebase_apple_auth_web-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "firebase_apple_auth_web-Swift.h"
#endif

@implementation FirebaseAppleAuthWebPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFirebaseAppleAuthWebPlugin registerWithRegistrar:registrar];
}
@end
