import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protocol_trace/protocol_trace.dart';
import 'package:secure_storage/secure_storage.dart';

/// The folder, under the app's external files directory, trace files are
/// written to: on Android `/sdcard/Android/data/<package>/files/protocol_traces`,
/// which `adb pull` reads without root or `run-as`.
const protocolTraceFolder = 'protocol_traces';

/// Whether the stored developer mode setting is on. Read straight from the
/// secure storage, as the profile is not loaded yet when the app starts.
Future<bool> _isDeveloperModeStored() async {
  final value = await getSecureStorage.get(SecureStorageKeys.isDeveloperMode);
  return value == 'true';
}

/// Starts the protocol trace at app start if developer mode was left on.
/// Must run before the first `HttpClient` is created, so before `runApp`.
Future<void> startProtocolTrace() async {
  try {
    final enabled = await _isDeveloperModeStored();
    await setProtocolTraceEnabled(enabled: enabled);
  } catch (e, s) {
    // Tracing is a debugging aid: never let it stop the app.
    getLogger(
      'ProtocolTrace',
    ).e('Protocol trace not started: $e', stackTrace: s);
  }
}

/// Turns the protocol trace on or off to follow developer mode: a trace holds
/// Device Tokens, DPoP proofs, attestations, access tokens and credentials, so
/// it is recorded only while developer mode is on. Turning it off keeps the
/// files already written.
///
/// Records every HTTP exchange of the app to protocol trace files laid out
/// like the wallet provider backend's `test-wallet-v1-*.log` traces.
Future<void> setProtocolTraceEnabled({required bool enabled}) async {
  if (!enabled) {
    ProtocolTrace.current = null;
    return;
  }
  if (ProtocolTrace.current != null) return;
  final log = getLogger('ProtocolTrace');
  try {
    final base =
        (Platform.isAndroid ? await getExternalStorageDirectory() : null) ??
        await getApplicationDocumentsDirectory();
    final packageInfo = await PackageInfo.fromPlatform();
    ProtocolTrace.current = ProtocolTrace(
      directory: Directory('${base.path}/$protocolTraceFolder'),
      appName: '${packageInfo.packageName} ${packageInfo.version}',
      initialMode: 'Developer mode on (wallet onboarding, configuration)',
      announce: log.i,
    );
    _installHttpOverrides();
  } catch (e, s) {
    ProtocolTrace.current = null;
    log.e('Protocol trace not started: $e', stackTrace: s);
  }
}

bool _httpOverridesInstalled = false;

/// Installed once, for the first trace: a client created before it is not
/// traced. It stays installed when the trace is turned off and then records
/// nothing, as the exchanges go to [ProtocolTrace.current], which is `null`.
void _installHttpOverrides() {
  if (_httpOverridesInstalled) return;
  _httpOverridesInstalled = true;
  HttpOverrides.global = TraceHttpOverrides(
    onExchange: (exchange) => ProtocolTrace.current?.recordExchange(exchange),
    previous: HttpOverrides.current,
    // Matrix chat long-polls `/_matrix/client/.../sync`, which would bury
    // the protocol exchanges.
    shouldTrace: (uri) =>
        ProtocolTrace.current != null &&
        !defaultIgnoredHosts.contains(uri.host) &&
        !uri.path.startsWith('/_matrix/'),
  );
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
