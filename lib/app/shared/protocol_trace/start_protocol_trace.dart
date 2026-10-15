import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protocol_trace/protocol_trace.dart';

/// The folder, under the app's external files directory, trace files are
/// written to: on Android `/sdcard/Android/data/<package>/files/protocol_traces`,
/// which `adb pull` reads without root or `run-as`.
const protocolTraceFolder = 'protocol_traces';

/// Records every HTTP exchange of the app to protocol trace files laid out
/// like the wallet provider backend's `test-wallet-v1-*.log` traces.
///
/// Debug builds only: a trace holds Device Tokens, DPoP proofs, attestations,
/// access tokens and credentials. Must run before the first `HttpClient` is
/// created, so before `runApp`.
Future<void> startProtocolTrace() async {
  // if (!kDebugMode) return;
  final log = getLogger('ProtocolTrace');
  try {
    final base =
        (Platform.isAndroid ? await getExternalStorageDirectory() : null) ??
        await getApplicationDocumentsDirectory();
    final packageInfo = await PackageInfo.fromPlatform();
    final trace = ProtocolTrace(
      directory: Directory('${base.path}/$protocolTraceFolder'),
      appName: '${packageInfo.packageName} ${packageInfo.version}',
      initialMode: 'App start (wallet onboarding, configuration)',
      announce: log.i,
    );
    ProtocolTrace.current = trace;
    HttpOverrides.global = TraceHttpOverrides(
      onExchange: trace.recordExchange,
      previous: HttpOverrides.current,
      // Matrix chat long-polls `/_matrix/client/.../sync`, which would bury
      // the protocol exchanges.
      shouldTrace: (uri) =>
          !defaultIgnoredHosts.contains(uri.host) &&
          !uri.path.startsWith('/_matrix/'),
    );
  } catch (e, s) {
    // Tracing is a debugging aid: never let it stop the app.
    log.e('Protocol trace not started: $e', stackTrace: s);
  }
}

/// Writes the error a flow stopped on, as shown to the user, to the protocol
/// trace. No-op unless tracing is on.
void traceFlowFailure(dynamic error) {
  final trace = ProtocolTrace.current;
  if (trace == null) return;
  trace.fail(switch (error) {
    ResponseMessage(:final message, :final data) =>
      'ResponseMessage(message: ${message?.name}, data: $data)',
    _ => '$error',
  });
}
