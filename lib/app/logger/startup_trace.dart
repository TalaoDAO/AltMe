import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

/// Runs [run] as the startup step [step].
///
/// The step is recorded as Sentry breadcrumbs (start, end and duration), so
/// any event sent later carries the trail of the steps that completed. If the
/// step is still pending after [warnAfter], a warning is sent right away:
/// a startup that hangs raises no error, and its release build prints no logs.
Future<T> traceStartup<T>(
  String step,
  Future<T> Function() run, {
  Duration warnAfter = const Duration(seconds: 5),
}) async {
  final stopwatch = Stopwatch()..start();
  _breadcrumb('$step: started');

  final watchdog = Timer(warnAfter, () {
    unawaited(
      Sentry.captureMessage(
        'Startup step "$step" still pending after ${warnAfter.inSeconds}s',
        level: SentryLevel.warning,
      ),
    );
  });

  try {
    final result = await run();
    _breadcrumb('$step: done in ${stopwatch.elapsedMilliseconds} ms');
    return result;
  } catch (error, stackTrace) {
    _breadcrumb(
      '$step: failed after ${stopwatch.elapsedMilliseconds} ms: $error',
      level: SentryLevel.error,
    );
    unawaited(
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({'startup_step': step}),
      ),
    );
    rethrow;
  } finally {
    watchdog.cancel();
  }
}

void _breadcrumb(String message, {SentryLevel level = SentryLevel.info}) {
  unawaited(
    Sentry.addBreadcrumb(
      Breadcrumb(message: message, category: 'startup', level: level),
    ),
  );
}
