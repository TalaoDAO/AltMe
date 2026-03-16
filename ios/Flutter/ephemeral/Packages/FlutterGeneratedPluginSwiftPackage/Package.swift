// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation"),
        .package(name: "flutter_secure_storage_darwin", path: "../.packages/flutter_secure_storage_darwin"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus"),
        .package(name: "mobile_scanner", path: "../.packages/mobile_scanner"),
        .package(name: "local_auth_darwin", path: "../.packages/local_auth_darwin"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios"),
        .package(name: "file_picker", path: "../.packages/file_picker"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus"),
        .package(name: "camera_avfoundation", path: "../.packages/camera_avfoundation"),
        .package(name: "beacon_flutter", path: "../.packages/beacon_flutter")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "flutter-secure-storage-darwin", package: "flutter_secure_storage_darwin"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "mobile-scanner", package: "mobile_scanner"),
                .product(name: "local-auth-darwin", package: "local_auth_darwin"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "camera-avfoundation", package: "camera_avfoundation"),
                .product(name: "beacon-flutter", package: "beacon_flutter")
            ]
        )
    ]
)
