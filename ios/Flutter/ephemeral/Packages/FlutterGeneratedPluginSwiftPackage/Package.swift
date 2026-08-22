// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "camera_avfoundation", path: "../.packages/camera_avfoundation-0.9.19+1"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-6.1.5"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus-13.2.0"),
        .package(name: "file_picker_darwin", path: "../.packages/file_picker_darwin-1.0.1"),
        .package(name: "flutter_image_compress_common", path: "../.packages/flutter_image_compress_common-1.1.1"),
        .package(name: "flutter_secure_storage_darwin", path: "../.packages/flutter_secure_storage_darwin-0.1.1"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios-0.8.13+6"),
        .package(name: "local_auth_darwin", path: "../.packages/local_auth_darwin-1.6.1"),
        .package(name: "mobile_scanner", path: "../.packages/mobile_scanner-7.4.0"),
        .package(name: "open_file_ios", path: "../.packages/open_file_ios-1.1.0"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-10.2.1"),
        .package(name: "permission_handler_apple", path: "../.packages/permission_handler_apple-9.6.1"),
        .package(name: "share_plus", path: "../.packages/share_plus-13.3.0"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.3+1"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.26.0"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "camera-avfoundation", package: "camera_avfoundation"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-picker-darwin", package: "file_picker_darwin"),
                .product(name: "flutter-image-compress-common", package: "flutter_image_compress_common"),
                .product(name: "flutter-secure-storage-darwin", package: "flutter_secure_storage_darwin"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "local-auth-darwin", package: "local_auth_darwin"),
                .product(name: "mobile-scanner", package: "mobile_scanner"),
                .product(name: "open-file-ios", package: "open_file_ios"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "permission-handler-apple", package: "permission_handler_apple"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
