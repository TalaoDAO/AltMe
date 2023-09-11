#import "FlutterOpensslCryptoPlugin.h"
#if __has_include(<flutter_openssl_crypto/flutter_openssl_crypto-Swift.h>)
#import <flutter_openssl_crypto/flutter_openssl_crypto-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_openssl_crypto-Swift.h"
#endif

@implementation FlutterOpensslCryptoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterOpensslCryptoPlugin registerWithRegistrar:registrar];
}
@end
