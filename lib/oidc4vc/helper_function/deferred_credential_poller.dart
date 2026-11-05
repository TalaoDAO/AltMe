import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

/// Collects deferred credentials while the app runs (OpenID4VCI 1.0 §9):
/// each pending card is asked for at the `interval` its issuer gave, then
/// again at each new `interval`, until the credential is stored or the
/// issuer refuses (an expired access token, an unknown transaction). A
/// refused card stays pending; "Get it now" still asks by hand.
class DeferredCredentialPoller {
  DeferredCredentialPoller({required this.fetch, this.now = DateTime.now});

  /// Asks the issuer once for the credential of a pending card: the wait
  /// before asking again, or null when there is nothing more to ask. Throws
  /// when the issuer refuses.
  final Future<Duration?> Function(CredentialModel pending) fetch;

  final DateTime Function() now;

  final _timers = <String, Timer>{};
  final _inFlight = <String>{};

  /// Cards not asked for again in this run: stored, refused, or asked by
  /// hand.
  final _stopped = <String>{};
  bool _disposed = false;

  final _log = getLogger('DeferredCredentialPoller');

  /// Polls the pending cards among [credentials] that are not polled yet,
  /// and stops polling cards no longer among them.
  void track(Iterable<CredentialModel> credentials) {
    if (_disposed) return;
    final pending = {
      for (final credential in credentials)
        if (credential.pendingInfo != null) credential.id: credential,
    };
    for (final id in _timers.keys.toList()) {
      if (!pending.containsKey(id)) _timers.remove(id)!.cancel();
    }
    for (final credential in pending.values) {
      if (_timers.containsKey(credential.id) ||
          _inFlight.contains(credential.id) ||
          _stopped.contains(credential.id)) {
        continue;
      }
      _schedule(credential, _firstWait(credential));
    }
  }

  /// Stops polling [id], e.g. while the user asks for it by hand.
  void stop(String id) {
    _timers.remove(id)?.cancel();
    _stopped.add(id);
  }

  /// Polls [credential] again after [wait].
  void resume(CredentialModel credential, Duration wait) {
    if (_disposed) return;
    _stopped.remove(credential.id);
    _timers.remove(credential.id)?.cancel();
    _schedule(credential, wait);
  }

  void dispose() {
    _disposed = true;
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  /// The issuer's `interval` from the time of the request, else 5 seconds.
  Duration _firstWait(CredentialModel credential) {
    final pendingInfo = credential.pendingInfo!;
    final interval = pendingInfo.encodedCredentialFromOIDC4VC['interval'];
    final seconds = interval is num && interval > 0 ? interval.ceil() : 5;
    final due = (pendingInfo.requestedAt ?? now()).add(
      Duration(seconds: seconds),
    );
    final wait = due.difference(now());
    return wait.isNegative ? Duration.zero : wait;
  }

  void _schedule(CredentialModel credential, Duration wait) {
    _timers[credential.id] = Timer(wait, () => _poll(credential));
  }

  Future<void> _poll(CredentialModel credential) async {
    _timers.remove(credential.id);
    _inFlight.add(credential.id);
    try {
      final next = await fetch(credential);
      if (next == null) {
        _stopped.add(credential.id);
      } else if (!_disposed && !_stopped.contains(credential.id)) {
        _schedule(credential, next);
      }
    } catch (e, s) {
      _log.e(
        'deferred credential ${credential.id} not collected: $e',
        error: e,
        stackTrace: s,
      );
      _stopped.add(credential.id);
    } finally {
      _inFlight.remove(credential.id);
    }
  }
}
