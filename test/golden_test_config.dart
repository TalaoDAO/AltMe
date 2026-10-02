// Golden tests for the Flutter app across various device screen sizes.
//
// To generate/update golden files with real fonts, run:
//   flutter test --update-goldens --tags=golden
//
// To run the golden tests:
//   flutter test test/golden_test.dart --tags=golden

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';


/// Load Material fonts for golden tests to display text properly
Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Load Roboto font variants from Flutter's material_fonts cache
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) {
    debugPrint('FLUTTER_ROOT not set, text may not render properly in goldens');
    return;
  }

  final fontVariants = [
    ('Roboto', 'Roboto-Regular.ttf'),
    ('Roboto', 'Roboto-Medium.ttf'),
    ('Roboto', 'Roboto-Bold.ttf'),
  ];

  for (final (fontFamily, fileName) in fontVariants) {
    final fontPath = '$flutterRoot/bin/cache/artifacts/material_fonts/$fileName';
    final file = File(fontPath);
    if (await file.exists()) {
      final fontLoader = FontLoader(fontFamily);
      final bytes = await file.readAsBytes();
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
      await fontLoader.load();
    }
  }
}

/// Device screen configuration for golden testing
class DeviceScreenSize {

  const DeviceScreenSize({
    required this.name,
    required this.size,
    this.devicePixelRatio = 1.0,
  });
  final String name;
  final Size size;
  final double devicePixelRatio;

  @override
  String toString() => name;
}

/// Common phone screen sizes
const phoneScreenSizes = [
  // iPhone SE (1st gen) / iPhone 5
  DeviceScreenSize(
    name: 'iPhone_SE_1st_gen',
    size: Size(320, 568),
    devicePixelRatio: 2,
  ),
  // iPhone 8 / iPhone SE (2nd & 3rd gen)
  DeviceScreenSize(
    name: 'iPhone_8_SE',
    size: Size(375, 667),
    devicePixelRatio: 2,
  ),
  // iPhone 12 / 13 / 14
  DeviceScreenSize(
    name: 'iPhone_12_13_14',
    size: Size(390, 844),
    devicePixelRatio: 3,
  ),
  // iPhone 12/13/14 Pro Max
  DeviceScreenSize(
    name: 'iPhone_Pro_Max',
    size: Size(428, 926),
    devicePixelRatio: 3,
  ),
  // iPhone 15 Pro
  DeviceScreenSize(
    name: 'iPhone_15_Pro',
    size: Size(393, 852),
    devicePixelRatio: 3,
  ),
  // Samsung Galaxy S21
  DeviceScreenSize(
    name: 'Samsung_Galaxy_S21',
    size: Size(360, 800),
    devicePixelRatio: 3,
  ),
  // Google Pixel 5
  DeviceScreenSize(
    name: 'Google_Pixel_5',
    size: Size(393, 851),
    devicePixelRatio: 2.75,
  ),
  // Google Pixel 7
  DeviceScreenSize(
    name: 'Google_Pixel_7',
    size: Size(412, 915),
    devicePixelRatio: 2.625,
  ),
    // iPad Mini
  DeviceScreenSize(
    name: 'iPad_Mini',
    size: Size(768, 1024),
    devicePixelRatio: 2,
  ),
  // iPad (10th gen)
  DeviceScreenSize(
    name: 'iPad_10th_gen',
    size: Size(820, 1180),
    devicePixelRatio: 2,
  ),
  // iPad Air
  DeviceScreenSize(
    name: 'iPad_Air',
    size: Size(820, 1180),
    devicePixelRatio: 2,
  ),
  // iPad Pro 11"
  DeviceScreenSize(
    name: 'iPad_Pro_11',
    size: Size(834, 1194),
    devicePixelRatio: 2,
  ),
  // iPad Pro 12.9"
  DeviceScreenSize(
    name: 'iPad_Pro_12_9',
    size: Size(1024, 1366),
    devicePixelRatio: 2,
  ),
  // Samsung Galaxy Tab S8
  DeviceScreenSize(
    name: 'Samsung_Galaxy_Tab_S8',
    size: Size(800, 1280),
    devicePixelRatio: 2,
  ),
  // Android Tablet (common 10" size)
  DeviceScreenSize(
    name: 'Android_Tablet_10',
    size: Size(800, 1280),
    devicePixelRatio: 1.5,
  ),
];
