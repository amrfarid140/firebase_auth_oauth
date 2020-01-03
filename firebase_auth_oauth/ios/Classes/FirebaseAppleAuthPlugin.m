#import "FirebaseAppleAuthPlugin.h"
#if __has_include(<firebase_auth_oauth/firebase_auth_oauth-Swift.h>)
#import <firebase_auth_oauth/firebase_auth_oauth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "firebase_auth_oauth-Swift.h"
#endif

@implementation FirebaseAppleAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFirebaseAppleAuthPlugin registerWithRegistrar:registrar];
}
@end
