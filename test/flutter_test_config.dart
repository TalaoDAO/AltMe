import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global test configuration to enable real font rendering in golden tests.
/// This file is automatically loaded by the Flutter test framework.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Load Material fonts for proper text rendering in golden tests
  await _loadMaterialFonts();

  await testMain();
}

/// Load Material fonts (Roboto) from Flutter's cache for golden tests
Future<void> _loadMaterialFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) {
    return;
  }

  final fontFiles = [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'Roboto-Light.ttf',
    'Roboto-Thin.ttf',
  ];

  for (final fileName in fontFiles) {
    final fontPath = '$flutterRoot/bin/cache/artifacts/material_fonts/$fileName';
    final file = File(fontPath);
    if (file.existsSync()) {
      final fontLoader = FontLoader('Roboto');
      final bytes = file.readAsBytesSync();
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
      await fontLoader.load();
    }
  }
}
