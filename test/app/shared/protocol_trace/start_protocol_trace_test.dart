import 'dart:io';

import 'package:altme/app/shared/protocol_trace/start_protocol_trace.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_trace/protocol_trace.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory documents;
  late HttpOverrides? previousOverrides;

  Directory traceFolder() =>
      Directory('${documents.path}/$protocolTraceFolder');

  List<FileSystemEntity> traceFiles() =>
      traceFolder().existsSync() ? traceFolder().listSync() : [];

  setUp(() {
    documents = Directory.systemTemp.createTempSync('protocol_trace_test');
    previousOverrides = HttpOverrides.current;
    PackageInfo.setMockInitialValues(
      appName: 'AltMe',
      packageName: 'co.altme.test',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => documents.path,
        );
  });

  tearDown(() async {
    ProtocolTrace.current = null;
    HttpOverrides.global = previousOverrides;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
    await documents.delete(recursive: true);
  });

  group('setProtocolTraceEnabled', () {
    test('creates no folder and no file while developer mode is off', () async {
      await setProtocolTraceEnabled(enabled: false);

      expect(ProtocolTrace.current, isNull);
      expect(traceFolder().existsSync(), isFalse);
    });

    test('writes a trace file once developer mode is on', () async {
      await setProtocolTraceEnabled(enabled: true);

      expect(ProtocolTrace.current, isNotNull);
      expect(traceFiles(), hasLength(1));
    });

    test('writes nothing more after developer mode is turned off again, '
        'and the files written earlier stay, only the developer menu hides '
        'them', () async {
      await setProtocolTraceEnabled(enabled: true);
      final written = traceFiles().single as File;
      final content = written.readAsStringSync();

      await setProtocolTraceEnabled(enabled: false);
      traceFlowFailure('after the switch was turned off');

      expect(ProtocolTrace.current, isNull);
      expect(traceFiles().map((f) => f.path), [written.path]);
      expect(written.readAsStringSync(), content);
    });
  });
}
