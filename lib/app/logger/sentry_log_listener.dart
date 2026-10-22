import 'dart:async';

import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Forwards every `log.e(...)`/`log.f(...)` call made through `getLogger`
/// to Sentry.
///
/// Most call sites in this app catch exceptions locally (to retry or skip
/// a step) and only surface them via the logger instead of rethrowing, so
/// they never reach `FlutterError.onError` or an uncaught zone error and
/// would otherwise never be reported.
void attachSentryLogListener() {
  Logger.addLogListener((event) {
    if (event.level < Level.error) return;

    final sentryLevel = event.level == Level.fatal
        ? SentryLevel.fatal
        : SentryLevel.error;

    final error = event.error;
    if (error != null) {
      unawaited(
        Sentry.captureException(
          error,
          stackTrace: event.stackTrace,
          hint: Hint.withMap({'logger_message': event.message.toString()}),
        ),
      );
    } else {
      // Many call sites embed the caught exception in the message string
      // (e.g. `log.e('Failed to fetch credential: $e')`) instead of passing
      // it as `error:`, so there's nothing to attach as a real exception.
      unawaited(
        Sentry.captureMessage(event.message.toString(), level: sentryLevel),
      );
    }
  });
}
